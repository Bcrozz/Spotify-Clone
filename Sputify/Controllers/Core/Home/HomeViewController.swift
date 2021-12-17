//
//  HomeViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendedTrack(viewModels: [RecommendedTrackCellViewModel])
    case userTopTracks(viewModels: [UserTopTracksCellViewModel])
    case userTopArtists(viewModels: [UserTopArtistsCellViewModel])
    
    var title: String {
        switch self {
        case .newReleases:
            return "New releases"
        case .featuredPlaylists:
            return "Feature albums"
        case .recommendedTrack:
            return "Recommendation tracks"
        case .userTopTracks:
            return "Your top tracks"
        case .userTopArtists:
            return "Your top artists"
        }
    }
}
/// Homeview in the mainTabbar
class HomeViewController: UIViewController {
    
    private var newAlbumReleases: [Album] = []
    private var featurePlaylists: [Playlist] = []
    private var recommendationTracks: [AudioTrack] = []
    private var userTopArtists: [Artist] = []
    private var userTopTracks: [AudioTrack] = []
    
    var browseCollectionView: UICollectionView! = nil
    
    private var sections = [BrowseSectionType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSetting))
        configCollectionView()
        fetchData()
    }
    
    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var playlistFeture: FeaturedPlaylists?
        var recommentResponse: RecommendationResponse?
        var topTracksResponse: UserTopTracksResponse?
        var topArtistsResponse: UserTopArtistsResponse?
        // new release list of album
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getNewReleases(accessToken: token,
                                                              limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = NewReleasesResponse.init(JSON: jsonData) {
                            newReleases = model
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
        //Featured playlists list of playlist
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getFeaturedPlaylists(accessToken: token,
                                                                    limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = FeaturedPlaylists.init(JSON: jsonData) {
                            playlistFeture = model
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
        //Recommend track list of track
        AuthManager.shared.withVaidToken { [weak self] token in
            APICaller.shared.provider.request(.getRecommendationGenres(accessToken: token)) { result in
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let recomGeres = RecommendationGenres(JSON: jsonData) {
                            let seeds = self?.randomSeed(genres: recomGeres.genres)
                            APICaller.shared.provider.request(.getRecommendations(accessToken: token,
                                                                                  seedGenre: seeds!,limit: 50)) { result in
                                defer {
                                    group.leave()
                                }
                                switch result {
                                case .success(let response):
                                    do{
                                        let jsonData = try response.mapJSON() as! [String: Any]
                                        if let model = RecommendationResponse.init(JSON: jsonData){
                                            recommentResponse = model
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
                    catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        //TopTracks
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getUserTopTracks(accessToken: token, limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = UserTopTracksResponse.init(JSON: jsonData) {
                            topTracksResponse = model
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
        //TopArtist
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getUserTopArtist(accessToken: token, limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = UserTopArtistsResponse.init(JSON: jsonData) {
                            topArtistsResponse = model
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
        
        group.notify(queue: .main){ [unowned self] in
            guard let releases = newReleases?.albumsResponse?.items,
                  let playlists = playlistFeture?.playlists?.items,
                  let tracks = recommentResponse?.tracks,
                  let topTracks = topTracksResponse?.items,
                  let topArtists = topArtistsResponse?.items else {
                        fatalError("Models are nil")
                    }
            print("Configureing viewModels")
            self.configureModel(newAlbums: releases,
                                playlists: playlists,
                                tracks: tracks,
                                topTracks: topTracks,
                                topArtists: topArtists)
        }
        
    }
    
    private func configureModel(newAlbums: [Album],
                                playlists: [Playlist],
                                tracks: [AudioTrack],
                                topTracks: [AudioTrack],
                                topArtists: [Artist]){
        
        self.newAlbumReleases = newAlbums
        self.featurePlaylists = playlists
        self.recommendationTracks = tracks
        self.userTopTracks = topTracks
        self.userTopArtists = topArtists
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            NewReleasesCellViewModel(name: $0.name,
                                     artworkURL: URL(string: $0.images?.first?.url ?? ""),
                                     numberOfTracks: $0.totalTracks,
                                     artistName: $0.artists?.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            FeaturedPlaylistCellViewModel(name: $0.name,
                                          artworkURL: URL(string: $0.images?.first?.url ?? ""),
                                          creatorName: $0.owner?.displayName ?? "-")
        })))
        sections.append(.recommendedTrack(viewModels: tracks.compactMap({
            RecommendedTrackCellViewModel(name: $0.name,
                                          artistName: $0.artists?.first?.name ?? "-",
                                          artworkURL: URL(string: $0.album?.images?.first?.url ?? ""))
        })))
        sections.append(.userTopArtists(viewModels: topArtists.compactMap({
            UserTopArtistsCellViewModel(name: $0.name,
                                        artworkURL: URL(string: $0.images?.first?.url ?? ""))
        })))
        sections.append(.userTopTracks(viewModels: topTracks.compactMap({
            UserTopTracksCellViewModel(name: $0.name,
                                       artistName: $0.artists?.first?.name ?? "-",
                                       artworkURL: URL(string: $0.album?.images?[1].url ?? ""),
                                       albumName: $0.album?.name ?? "-")
        })))
        browseCollectionView.reloadData()
    }
                                                            
    @objc func didTapSetting(){
        let settingVC = SettingViewController(nibName: "SettingViewController", bundle: nil)
        settingVC.navigationItem.title = "Settings"
        settingVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
}

extension HomeViewController {
    
    func randomSeed(genres: [String]?) -> Set<String>? {
        guard let genres = genres else {
            return nil
        }
        var seeds = Set<String>()
        while seeds.count < 5 {
            if let random = genres.randomElement() {
                seeds.insert(random)
            }
        }
        return seeds
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let type = sections[section]
        
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTrack(let viewModels):
            return viewModels.count
        case .userTopTracks(let viewModels):
            return viewModels.count
        case .userTopArtists(viewModels: let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        
        switch type {
        case .newReleases(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as! NewReleaseCollectionViewCell
            cell.backgroundColor = UIColor(named: "cellColor")!
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredPlaylists(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturePlaylistCollectionViewCell
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .recommendedTrack(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as! RecommendedTrackCollectionViewCell
            let viewModel = viewModels[indexPath.row]
            cell.backgroundColor = UIColor(named: "cellColor")!
            cell.configure(with: viewModel)
            return cell
        case .userTopTracks(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopTracksCollectionViewCell.identifier, for: indexPath) as! TopTracksCollectionViewCell
            cell.backgroundColor = UIColor(named: "cellColor")!
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .userTopArtists(let viewModels):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopArtistsCollectionViewCell.identifier, for: indexPath) as! TopArtistsCollectionViewCell
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderBrowseCollectionView.identifier, for: indexPath) as! HeaderBrowseCollectionView
        
        let section = indexPath.section
        let title = sections[section].title
        header.headerLabel.text = title
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        
        switch section {
        case .newReleases:
            let album = newAlbumReleases[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .featuredPlaylists:
            let playlist = featurePlaylists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.navigationItem.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTrack:
            print("")
        case .userTopArtists:
            let artist = userTopArtists[indexPath.row]
            let vc = ArtistViewController(artist: artist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .userTopTracks:
            print("")
        }
    }
    
    
    
    
    private func configCollectionView(){
        browseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        browseCollectionView.translatesAutoresizingMaskIntoConstraints = false
        browseCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        browseCollectionView.register(UINib(nibName: "NewReleaseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        browseCollectionView.register(UINib(nibName: "FeaturePlaylistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier)
        browseCollectionView.register(UINib(nibName: "RecommendedTrackCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        browseCollectionView.register(UINib(nibName: "TopTracksCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TopTracksCollectionViewCell.identifier)
        browseCollectionView.register(UINib(nibName: "TopArtistsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TopArtistsCollectionViewCell.identifier)
        browseCollectionView.register(UINib(nibName: "HeaderBrowseCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderBrowseCollectionView.identifier)
        browseCollectionView.backgroundColor = UIColor(named: "blackSpotify")!
        browseCollectionView.dataSource = self
        browseCollectionView.delegate = self
        
        view.addSubview(browseCollectionView)
        
        NSLayoutConstraint.activate([
            browseCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            browseCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            browseCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            browseCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionIndex,_  in
            var returnsection: NSCollectionLayoutSection! = nil
            switch sectionIndex{
            case 0:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                
                let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: item, count: 2)
                verticalGroup.interItemSpacing = .fixed(10)
                
                let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80), heightDimension: .estimated(245))
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [verticalGroup])
                horizontalGroup.interItemSpacing = .fixed(18)
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 18)
                section.interGroupSpacing = 18
                
                returnsection = section
            case 1,3:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                
                let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80), heightDimension: .estimated(sectionIndex == 1 ? 220 : 200))
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitem: item, count: 2)
                horizontalGroup.interItemSpacing = .fixed(18)
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 18)
                section.interGroupSpacing = 18
                
                returnsection = section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: item, count: 3)
                verticalGroup.interItemSpacing = .fixed(10)
                
                let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80), heightDimension: .estimated(300))
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [verticalGroup])
                horizontalGroup.interItemSpacing = .fixed(18)
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 18)
                section.interGroupSpacing = 18
                
                returnsection = section
            }
            
            let HeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: HeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
            returnsection.boundarySupplementaryItems = [sectionHeader]
            
            return returnsection
        }
        
        return layout
    }
    
}
