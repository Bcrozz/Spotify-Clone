//
//  LibraryViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import UIKit

class LibraryViewController: UIViewController {
    
    private let playlistVC = LibraryPlaylistViewController(nibName: "LibraryPlaylistViewController", bundle: nil)
    private let albumsVC = LibraryAlbumsViewController(nibName: "LibraryAlbumsViewController", bundle: nil)
    
    @IBOutlet weak var indicatorTabView: LibraryToggleView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorTabView.delegate = self
        scrollView.delegate = self
        addChildren()
    }


    private func addChildren(){
        addChild(playlistVC)
        contentScrollView.addSubview(playlistVC.view)
        playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        playlistVC.didMove(toParent: self)
        
        addChild(albumsVC)
        contentScrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        albumsVC.didMove(toParent: self)
    }
    
}

extension LibraryViewController: LibraryToggleViewDelegate {
    
    func libraryToggleViewdidTapPlaylist(_ toggleView: LibraryToggleView) {
        
        UIView.animate(withDuration: 0.25) {
            toggleView.rightIndicatorConstraint.isActive = false
            toggleView.leftIndicatorConstraint.isActive = true
            toggleView.layoutIfNeeded()
        }
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewdidTapAlbum(_ toggleView: LibraryToggleView) {
        
        UIView.animate(withDuration: 0.25) {
            toggleView.leftIndicatorConstraint.isActive = false
            toggleView.rightIndicatorConstraint.isActive = true
            toggleView.layoutIfNeeded()
        }
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
    }
    
    
}

extension LibraryViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.bounds.width - 100) {
            indicatorTabView.updateState(for: .Album)
        }else {
            indicatorTabView.updateState(for: .Playlist)
        }
    }
}
