//
//  LibraryToggleView.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 17/11/21.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewdidTapPlaylist(_ toggleView: LibraryToggleView)
    func libraryToggleViewdidTapAlbum(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum TypeToggle {
        case Playlist
        case Album
    }
    
    weak var delegate: LibraryToggleViewDelegate?
    
    @IBOutlet weak var leftIndicatorConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightIndicatorConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    
    
    private func loadFromNib(){
        let nib = UINib(nibName: "LibraryToggleView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
        }
    }
    
    @IBAction func didTapPlaylistButton(_ sender: Any) {
        delegate?.libraryToggleViewdidTapPlaylist(self)
    }
    
    @IBAction func didTapAlbumButton(_ sender: Any) {
        delegate?.libraryToggleViewdidTapAlbum(self)
    }
    
    func updateState(for type: TypeToggle){
        switch type {
        case .Playlist:
            layoutIfNeeded()
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.rightIndicatorConstraint.isActive = false
                self?.leftIndicatorConstraint.isActive = true
                self?.layoutIfNeeded()
            }
        case .Album:
            layoutIfNeeded()
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.leftIndicatorConstraint.isActive = false
                self?.rightIndicatorConstraint.isActive = true
                self?.layoutIfNeeded()
            }
        }
    }
    
}
