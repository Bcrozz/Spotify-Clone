//
//  ArtistTopTracksCollectionViewCell.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 16/11/21.
//

import UIKit
import SDWebImage

class ArtistTopTracksCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ArtistTopTracksCollectionViewCell"
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        trackNumberLabel.text = nil
    }
    
    func configure(with viewModel: ArtistTopTracksCellViewModel, number: Int){
        trackNumberLabel.text = "\(number)"
        trackNameLabel.text = viewModel.name ?? ""
        albumImageView.sd_setImage(with: viewModel.albumArtworkURL, completed: nil)
    }

}
