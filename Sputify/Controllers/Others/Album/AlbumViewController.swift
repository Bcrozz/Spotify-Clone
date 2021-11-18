//
//  AlbumViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album: Album
    
    private var albumCollectionView: UICollectionView! = nil
    
    init(album: Album){
        self.album = album
        super.init(nibName: "AlbumViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModels = [AlbumCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = album.name
        navigationItem.titleView?.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToPrevious))
        configCollectionView()
        fetchData()
    }
    
    private func fetchData(){
        AuthManager.shared.withVaidToken { [unowned self] token in
            APICaller.shared.provider.request(.getAlbumDetail(accessToken: token, id: self.album.id ?? ""),callbackQueue: .main) { result in
                
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = AlbumsDetailResponse(JSON: jsonData){
                            self.viewModels = model.tracks?.items.compactMap({
                                AlbumCellViewModel(name: $0.name, artistName: $0.artists?.first?.name ?? "")
                            }) ?? [AlbumCellViewModel]()
                            self.albumCollectionView.backgroundView = getGradientLayer(with: albumCollectionView.bounds)
                            self.albumCollectionView.reloadData()
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    @objc private func backToPrevious(){
        navigationController?.popViewController(animated: true)
    }
    
    private func getGradientLayer(with size: CGRect) -> UIView{
        let imageCover = UIImageView()
        imageCover.sd_setImage(with: URL(string: album.images?[1].url ?? ""), completed: nil)
        let avgColorImage = imageCover.image?.averageColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = size
        gradientLayer.colors = [
            avgColorImage?.cgColor,
            UIColor(named: "blackSpotify")!
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        let bgView = UIView(frame: size)
        bgView.layer.insertSublayer(gradientLayer, at: 0)
        return bgView
    }

}

extension AlbumViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 15
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 20, trailing: 15)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.6))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
            
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }
    
    private func configCollectionView() {
        albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        albumCollectionView.translatesAutoresizingMaskIntoConstraints = false
        albumCollectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        albumCollectionView.register(UINib(nibName: "AlbumCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AlbumCollectionReusableView.identifier)
        albumCollectionView.backgroundColor = UIColor(named: "blackSpotify")!
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        
        view.addSubview(albumCollectionView)
        
        NSLayoutConstraint.activate([
            albumCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            albumCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            albumCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            albumCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as! AlbumCollectionViewCell
        
        cell.configure(with :viewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AlbumCollectionReusableView.identifier, for: indexPath) as! AlbumCollectionReusableView
        
        let headerViewModel = AlbumHeaderViewModel(name: album.name,
                                                   artistName: album.artists?.first?.name ?? "",
                                                   artworkURL: URL(string: album.images?[1].url ?? ""),
                                                   artistImageURL: URL(string: album.artists?.first?.images?[0].url ?? ""))
        
        header.configure(with: headerViewModel)
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}

extension AlbumViewController: AlbumCollectionReusableViewDelegate {
    
    func AlbumCollectionReusableViewDidTapPlayAll(_ header: AlbumCollectionReusableView) {
        print("aaa")
    }
    
    
}
