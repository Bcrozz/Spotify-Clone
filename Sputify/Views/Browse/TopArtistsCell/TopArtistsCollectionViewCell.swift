//
//  TopArtistCollectionViewCell.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import UIKit
import SDWebImage

class TopArtistsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopArtistsCollectionViewCell"

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistName.text = nil
    }
    
    func configure(with viewModel: UserTopArtistsCellViewModel){
        artistName.text = viewModel.name
        artistImageView.layer.cornerRadius = artistImageView.bounds.width/2
        artistImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }

}
