//
//  AlbumCollectionReusableView.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import UIKit
import SDWebImage

protocol AlbumCollectionReusableViewDelegate: AnyObject {
    func AlbumCollectionReusableViewDidTapPlayAll(_ header: AlbumCollectionReusableView)
}

class AlbumCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: AlbumCollectionReusableViewDelegate?
    
    static let identifier = "AlbumCollectionReusableView"
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    @IBAction func didTapPlayAll(_ sender: Any) {
        delegate?.AlbumCollectionReusableViewDidTapPlayAll(self)
    }
    
    func configure(with viewModel: AlbumHeaderViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        artistImageView.sd_setImage(with: viewModel.artistImageURL, completed: nil)
    }
    
}
