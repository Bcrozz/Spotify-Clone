//
//  CategoriesCollectionViewCell.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import UIKit
import SDWebImage

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoriesCollectionViewCell"

    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var categoryPlaylistImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        ownerNameLabel.text = nil
    }

    func configure(with viewModel:FeaturedPlaylistCellViewModel){
        playlistNameLabel.text = viewModel.name
        ownerNameLabel.text = viewModel.creatorName
        categoryPlaylistImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    
}
