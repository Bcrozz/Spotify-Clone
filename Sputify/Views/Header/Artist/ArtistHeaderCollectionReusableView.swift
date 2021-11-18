//
//  ArtistHeaderCollectionReusableView.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 16/11/21.
//

import UIKit


class ArtistHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ArtistHeaderCollectionReusableView"
    @IBOutlet weak var coverArtistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text = nil
    }
    
    func configure(with model: Artist){
        coverArtistImageView.sd_setImage(with: URL(string: model.images?.first?.url ?? ""), completed: nil)
        artistNameLabel.text = model.name
    }
    
}
