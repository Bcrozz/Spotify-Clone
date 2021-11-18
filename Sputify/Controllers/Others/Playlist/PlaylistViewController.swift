//
//  PlaylistViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import UIKit
import SDWebImage

class PlaylistViewController: UIViewController {
    
    private let playlist: Playlist
    
    private var playlistCollectionView: UICollectionView! = nil
    
    init(playlist: Playlist){
        self.playlist = playlist
        super.init(nibName: "PlaylistViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModels = [RecommendedTrackCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = playlist.name
        navigationItem.titleView?.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToHome))
        navigationController?.navigationBar.isTranslucent = true
        configCollectionView()
        fetchData()
    }

    private func fetchData(){
        AuthManager.shared.withVaidToken { [unowned self] token in
            APICaller.shared.provider.request(.getPlaylistDetail(accessToken: token, id: self.playlist.id ?? ""),callbackQueue: .main) { result in
                
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = PlaylistDetailResponse(JSON: jsonData){
                            self.viewModels = model.tracksInList?.items.compactMap({
                                RecommendedTrackCellViewModel(name: $0.track?.name,
                                                              artistName: $0.track?.artists?.first?.name ?? "-",
                                                              artworkURL: URL(string: $0.track?.album?.images?[1].url ?? ""))
                            }) ?? [RecommendedTrackCellViewModel]()
                            self.playlistCollectionView.backgroundView = getGradientLayer(with: playlistCollectionView.bounds)
                            self.playlistCollectionView.reloadData()
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
    
    @objc private func backToHome(){
        navigationController?.popViewController(animated: true)
    }
    
    private func getGradientLayer(with size: CGRect) -> UIView{
        let imageCover = UIImageView()
        imageCover.sd_setImage(with: URL(string: playlist.images?.first?.url ?? ""), completed: nil)
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

extension PlaylistViewController {
    
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
        playlistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        playlistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        playlistCollectionView.register(UINib(nibName: "PlaylsitCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier)
        playlistCollectionView.register(UINib(nibName: "PlaylistCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistCollectionReusableView.identifier)
        playlistCollectionView.backgroundColor = UIColor(named: "blackSpotify")!
        playlistCollectionView.dataSource = self
        playlistCollectionView.delegate = self
        
        view.addSubview(playlistCollectionView)
        
        NSLayoutConstraint.activate([
            playlistCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playlistCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playlistCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playlistCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension PlaylistViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as! PlaylsitCollectionViewCell
        
        cell.configure(with :viewModels[indexPath.row])
        cell.backgroundColor = nil
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistCollectionReusableView.identifier, for: indexPath) as! PlaylistCollectionReusableView
        let headerViewModel = PlaylistHeaderViewModel(name: playlist.name, ownerName: playlist.owner?.displayName ?? "-", description: playlist.description, artworkURL: URL(string: playlist.images?.first?.url ?? ""))
        
        header.configure(with: headerViewModel)
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}

extension PlaylistViewController: PlaylistCollectionReusableViewDelegate {
    func PlaylistCollectionReusableViewDidTapPlayAll(_ header: PlaylistCollectionReusableView) {
        // Start play list
        print("playing all")
    }
}
