//
//  SearchResultViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 15/11/21.
//

import UIKit

enum SearchResponse {
    case playlists(title: String,models: [Playlist])
    case albums(title: String,models: [Album])
    case tracks(title: String,models: [AudioTrack])
    case artists(title: String,models: [Artist])
}

protocol SearchResultViewControllerDelegate: AnyObject {
    func showResult(_ controller: UIViewController)
}

class SearchResultViewController: UIViewController {
    
    private var sections: [SearchResponse] = []
    
    var searchResultCollectionView: UICollectionView! = nil
    
    weak var delegate: SearchResultViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
    }

    func update(with result: SearchResultResponse){
        sections = [
            .tracks(title: "Songs", models: result.tracks ?? [AudioTrack]()),
            .artists(title: "Artists", models: result.artists ?? [Artist]()),
            .albums(title: "Albums", models: result.albums ?? [Album]()),
            .playlists(title: "Playlists", models: result.playlists ?? [Playlist]())
        ]
        searchResultCollectionView.reloadData()
        searchResultCollectionView.isHidden = false
    }
    
    func clearResult() {
        sections.removeAll()
        searchResultCollectionView.reloadData()
        searchResultCollectionView.isHidden = true
    }

}

extension SearchResultViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            var finalSection: NSCollectionLayoutSection! = nil
            switch sectionIndex {
            case 0:
                //Songs
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: item, count: 3)
                verticalGroup.interItemSpacing = .fixed(10)
                
                let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80), heightDimension: .fractionalHeight(0.45))
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [verticalGroup])
                horizontalGroup.interItemSpacing = .fixed(18)
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 18)
                section.interGroupSpacing = 18
                
                finalSection = section
                
            default:
                //artist,album,playlist
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                
                let horizontalGroupSize: NSCollectionLayoutSize
                if sectionIndex == 1{
                    horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80), heightDimension: .fractionalWidth(1/2))
                }else if sectionIndex == 2 {
                    horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80), heightDimension: .fractionalWidth(1.2/2))
                }else {
                    horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.80), heightDimension: .fractionalWidth(1.1/2))
                }
                
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitem: item, count: 2)
                horizontalGroup.interItemSpacing = .fixed(18)
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 18)
                section.interGroupSpacing = 18
                
                finalSection = section
                
            }
            
            let HeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: HeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
            finalSection.boundarySupplementaryItems = [sectionHeader]
            
            return finalSection
        }
        
        return layout
        
    }
    
    private func configCollectionView() {
        
        searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        searchResultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchResultCollectionView.register(UINib(nibName: "TopTracksCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TopTracksCollectionViewCell.identifier)
        searchResultCollectionView.register(UINib(nibName: "TopArtistsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TopArtistsCollectionViewCell.identifier)
        searchResultCollectionView.register(UINib(nibName: "FeaturePlaylistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier)
        searchResultCollectionView.register(UINib(nibName: "HeaderBrowseCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderBrowseCollectionView.identifier)
        searchResultCollectionView.backgroundColor = UIColor(named: "blackSpotify")!
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.delegate = self
        
        view.addSubview(searchResultCollectionView)
        
        NSLayoutConstraint.activate([
            searchResultCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchResultCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchResultCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        searchResultCollectionView.isHidden = true
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch sections[section]{
        case .tracks(_, let models):
            return models.count
        case .artists(_,let models):
            return models.count
        case .albums(_,let models):
            return models.count
        case .playlists(_,let models):
            return models.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section]{
        case .tracks(_, let models):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopTracksCollectionViewCell.identifier, for: indexPath) as! TopTracksCollectionViewCell
            let model = models[indexPath.row]
            let viewModel = UserTopTracksCellViewModel(name: model.name, artistName: model.artists?.first?.name, artworkURL: URL(string: model.album?.images?.first?.url ?? ""), albumName: model.album?.name)
            cell.configure(with: viewModel)
            cell.backgroundColor = UIColor(named: "cellColor")!
            return cell
        case .artists(_,let models):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopArtistsCollectionViewCell.identifier, for: indexPath) as! TopArtistsCollectionViewCell
            let model = models[indexPath.row]
            let viewModel = UserTopArtistsCellViewModel(name: model.name, artworkURL: URL(string: model.images?.first?.url ?? ""))
            cell.configure(with: viewModel)
            cell.backgroundColor = nil
            return cell
        case .albums(_,let models):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturePlaylistCollectionViewCell
            let model = models[indexPath.row]
            let viewModel = FeaturedPlaylistCellViewModel(name: model.name, artworkURL: URL(string: model.images?.first?.url ?? ""), creatorName: model.artists?.first?.name ?? "-")
            cell.configure(with: viewModel)
            cell.backgroundColor = nil
            return cell
        case .playlists(_,let models):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturePlaylistCollectionViewCell
            let model = models[indexPath.row]
            let viewModel = FeaturedPlaylistCellViewModel(name: model.name, artworkURL: URL(string: model.images?.first?.url ?? ""), creatorName: model.owner?.displayName)
            cell.configure(with: viewModel)
            cell.backgroundColor = nil
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderBrowseCollectionView.identifier, for: indexPath) as! HeaderBrowseCollectionView
        
        switch sections[indexPath.section]{
        case .tracks(let title,_):
            header.headerLabel.text = title
        case .artists(let title,_):
            header.headerLabel.text = title
        case .albums(let title,_):
            header.headerLabel.text = title
        case .playlists(let title,_):
            header.headerLabel.text = title
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch sections[indexPath.section]{
        case .tracks:
            print("")
        case .artists(_,let model):
            let artist = model[indexPath.row]
            let vc = ArtistViewController(artist: artist)
            vc.navigationItem.largeTitleDisplayMode = .never
            delegate?.showResult(vc)
        case .albums(_,let models):
            let album = models[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            delegate?.showResult(vc)
        case .playlists(_,let models):
            let playlist = models[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            delegate?.showResult(vc)
        }
    }
    
    
}
