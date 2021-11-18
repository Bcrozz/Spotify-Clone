//
//  ArtistViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 16/11/21.
//
// getarits 3 image,album 3 image,
import UIKit
import Moya

enum ArtistResponseViewModel {
    case ArtistAlbum(models: [ArtistAlbumCellViewModel])
    case AritstTopTracks(models: [ArtistTopTracksCellViewModel])
    case ArtistRelatedArtists(models: [ArtistRelatedCellViewModel])
}


class ArtistViewController: UIViewController {
    
    private var artist: Artist
    private var artistAlbum: [Album] = []
    private var artistTopTracks: [AudioTrack] = []
    private var artistRelatedArtists: [Artist] = []
    
    private var sections: [ArtistResponseViewModel] = []
    
    private var collectionView: UICollectionView! = nil
    
    init(artist: Artist){
        self.artist = artist
        super.init(nibName: "ArtistViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = artist.name
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToPrevious))
        configureCollectionView()
        fetchData()
    }
    
    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        var artistResponse: Artist?
        var artistTopTracksResponse: [AudioTrack]?
        var artistAlbumResponse: [Album]?
        var artistRelatedResponse: [Artist]?
        
        AuthManager.shared.withVaidToken { [unowned self] token in
            APICaller.shared.provider.request(.getArtist(accessToken: token, id: self.artist.id ?? "")) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = Artist(JSON: jsonData) {
                            artistResponse = model
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription,error.response?.statusCode)
                }
    
            }
        }
        
        AuthManager.shared.withVaidToken { [unowned self] token in
            APICaller.shared.provider.request(.getArtistTopTracks(accessToken: token, id: self.artist.id ?? "")) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = ArtistTopTracksResponse(JSON: jsonData) {
                            artistTopTracksResponse = model.tracks
                        }
                    }
                    catch {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription,error.response?.statusCode)
                }
    
            }
        }
        
        AuthManager.shared.withVaidToken { [unowned self] token in
            APICaller.shared.provider.request(.getArtistAlbums(accessToken: token, id: self.artist.id ?? "", limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = ArtistAlbumsResponse(JSON: jsonData){
                            artistAlbumResponse = model.items
                        }
                    }
                    catch {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription,error.response?.statusCode)
                }
    
            }
        }
        
        AuthManager.shared.withVaidToken { [unowned self] token in
            APICaller.shared.provider.request(.getArtistRelateArtists(accessToken: token, id: self.artist.id ?? "")) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = ArtistRelatedArtistsResponse(JSON: jsonData) {
                            artistRelatedResponse = model.artists
                        }
                    }
                    catch {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription,error.response?.statusCode)
                }
    
            }
        }
        
        group.notify(queue: .main) { [unowned self] in
            guard let artist = artistResponse,
                  let artistTopTracks = artistTopTracksResponse,
                  let artistAlbums = artistAlbumResponse,
                  let artistRelated = artistRelatedResponse else {
                      fatalError("Models are nil")
                  }
            print("Configureing artist viewModels")
            self.configureModel(artist: artist, artistTopTracks: artistTopTracks, artistAlbum: artistAlbums, relatedArtists: artistRelated)
        }
    }
    
    private func configureModel(artist: Artist,artistTopTracks: [AudioTrack],artistAlbum: [Album], relatedArtists: [Artist]){
        self.artist = artist
        self.artistTopTracks = artistTopTracks
        self.artistAlbum = artistAlbum
        self.artistRelatedArtists = relatedArtists
        
        sections.append(.AritstTopTracks(models: artistTopTracks.compactMap({
            ArtistTopTracksCellViewModel(name: $0.name, trackNumber: $0.trackNumber, albumArtworkURL: URL(string: $0.album?.images?[2].url ?? ""))
        })))
        
        sections.append(.ArtistAlbum(models: artistAlbum.compactMap({
            ArtistAlbumCellViewModel(albumType: $0.albumType, releaseYear: $0.releaseData, name: $0.name, totalTracks: $0.totalTracks, artworkURL: URL(string: $0.images?[1].url ?? ""))
        })))
        
        sections.append(.ArtistRelatedArtists(models: relatedArtists.compactMap({
            ArtistRelatedCellViewModel(name: $0.name, artworkURL: URL(string: $0.images?.first?.url ?? ""))
        })))
        
        collectionView.reloadData()
        
    }
    
    @objc private func backToPrevious(){
        navigationController?.popViewController(animated: true)
    }


}

extension ArtistViewController {
    
    private func createLayout() ->  UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            var section: NSCollectionLayoutSection! = nil
            
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(45))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
                section.interGroupSpacing = 10
                
                let mainHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.45))
                let mainHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: mainHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [mainHeader]
                
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let threeVerticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let threeVerticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: threeVerticalGroupSize, subitem: item, count: 3)
                threeVerticalGroup.interItemSpacing = .fixed(15)
                
                let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80), heightDimension: .estimated(330))
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [threeVerticalGroup])
                
                section = NSCollectionLayoutSection(group: horizontalGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 20)
                section.interGroupSpacing = 15
                section.orthogonalScrollingBehavior = .groupPaging
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
            default:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let twoGroupHorizontalSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(200))
                let twoGroupHorizontal = NSCollectionLayoutGroup.horizontal(layoutSize: twoGroupHorizontalSize, subitem: item, count: 2)
                twoGroupHorizontal.interItemSpacing = .fixed(15)
                
                section = NSCollectionLayoutSection(group: twoGroupHorizontal)
                section.orthogonalScrollingBehavior = .groupPaging
                section.interGroupSpacing = 15
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 20)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
            }
            
            return section
        }
        
        return layout
    }
    
    private func configureCollectionView(){
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: "ArtistTopTracksCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ArtistTopTracksCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "ArtistAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ArtistAlbumCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "ArtistRelatedArtistsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ArtistRelatedArtistsCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "ArtistHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ArtistHeaderCollectionReusableView.identifier)
        collectionView.register(UINib(nibName: "HeaderBrowseCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderBrowseCollectionView.identifier)
        collectionView.backgroundColor = UIColor(named: "blackSpotify")!
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
}

extension ArtistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .AritstTopTracks(let models):
            return models.count
        case .ArtistAlbum(let models):
            return models.count
        case .ArtistRelatedArtists(let models):
            return models.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
        case .AritstTopTracks(let models):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistTopTracksCollectionViewCell.identifier, for: indexPath) as! ArtistTopTracksCollectionViewCell
            let model = models[indexPath.row]
            
            cell.configure(with: model,number: indexPath.row + 1)
            cell.backgroundColor = nil
            
            return cell
            
        case .ArtistAlbum(let models):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistAlbumCollectionViewCell.identifier, for: indexPath) as! ArtistAlbumCollectionViewCell
            let model = models[indexPath.row]
            
            cell.configure(with: model)
            cell.backgroundColor = UIColor(named: "cellColor")!
            
            return cell
        case .ArtistRelatedArtists(let models):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistRelatedArtistsCollectionViewCell.identifier, for: indexPath) as! ArtistRelatedArtistsCollectionViewCell
            let model = models[indexPath.row]
            
            cell.configure(with: model)
            cell.backgroundColor = nil
            
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch sections[indexPath.section]{
        case .AritstTopTracks:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ArtistHeaderCollectionReusableView.identifier, for: indexPath) as! ArtistHeaderCollectionReusableView
            header.configure(with: self.artist)
            
            return header
        case .ArtistAlbum:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderBrowseCollectionView.identifier, for: indexPath) as! HeaderBrowseCollectionView
            header.headerLabel.text = "Album releases"
            
            return header
        case .ArtistRelatedArtists:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderBrowseCollectionView.identifier, for: indexPath) as! HeaderBrowseCollectionView
            header.headerLabel.text = "Relate artists"
            
            return header
        }


    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch sections[indexPath.section]{
        case .AritstTopTracks:
            break
        case .ArtistAlbum:
            let album = artistAlbum[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .ArtistRelatedArtists:
            let artist = artistRelatedArtists[indexPath.row]
            let vc = ArtistViewController(artist: artist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
