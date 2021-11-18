//
//  PlaylsitCollectionViewCell.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import UIKit
import SDWebImage

class PlaylsitCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlaylsitCollectionViewCell"
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var extendButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapExtendButton(_ sender: Any) {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel){
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        trackImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    func configure(with viewModel: UserPlaylistCellViewModel){
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.owner
        trackImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    func hidenButton(){
        extendButton.isHidden = true
    }
}
