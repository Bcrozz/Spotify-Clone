//
//  FeaturePlaylistCollectionViewCell.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 13/11/21.
//

import UIKit
import SDWebImage

class FeaturePlaylistCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeaturePlaylistCollectionViewCell"
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
    }
    
    func configure(with viewModel:FeaturedPlaylistCellViewModel){
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }

}
