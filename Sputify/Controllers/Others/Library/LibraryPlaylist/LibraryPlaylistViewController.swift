//
//  LibraryPlaylistViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 17/11/21.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    
    private var collectionView: UICollectionView! = nil
    
    private var viewModels = [UserPlaylistCellViewModel]()
    
    private var playlists = [Playlist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchData()
    }

    private func fetchData(){
        AuthManager.shared.withVaidToken { [unowned self] token in
            APICaller.shared.provider.request(.getUserPlaylist(accessToken: token, limit: 50),callbackQueue: .main) { result in
                
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = UserPlaylistResponse(JSON: jsonData) {
                            self.viewModels = model.items?.compactMap({
                                UserPlaylistCellViewModel(name: $0.name, type: $0.type, owner: $0.owner?.displayName, artworkURL: URL(string: $0.images?.first?.url ?? ""))
                            }) ?? [UserPlaylistCellViewModel]()
                            self.playlists = model.items ?? [Playlist]()
                            self.collectionView.reloadData()
                        }
                    }catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}

extension LibraryPlaylistViewController {
    
    private func createLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { section, _ in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 15
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 20, trailing: 15)
            
            return section
        }
        
        return layout
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "PlaylsitCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PlaylsitCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(named: "blackSpotify")!
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension LibraryPlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylsitCollectionViewCell.identifier, for: indexPath) as! PlaylsitCollectionViewCell
        
        let model = viewModels[indexPath.row]
        cell.configure(with: model)
        cell.backgroundColor = nil
        cell.hidenButton()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.title = playlist.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
