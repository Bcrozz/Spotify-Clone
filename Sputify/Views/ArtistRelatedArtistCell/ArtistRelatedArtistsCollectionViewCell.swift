//
//  ArtistRelatedArtistsCollectionViewCell.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 16/11/21.
//

import UIKit
import SDWebImage

class ArtistRelatedArtistsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ArtistRelatedArtistsCollectionViewCell"

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text = nil
    }
    
    func configure(with viewModel: ArtistRelatedCellViewModel){
        artistNameLabel.text = viewModel.name
        artistImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
}
