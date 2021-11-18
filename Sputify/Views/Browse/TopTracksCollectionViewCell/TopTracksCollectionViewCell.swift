//
//  TopTracksCollectionViewCell.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 13/11/21.
//

import UIKit

class TopTracksCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopTracksCollectionViewCell"
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumNameLabel.text = nil
    }
    
    func configure(with viewModel: UserTopTracksCellViewModel){
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumNameLabel.text = viewModel.albumName
        albumImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }

}
