//
//  PlaylistCollectionReusableView.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import UIKit
import SDWebImage

protocol PlaylistCollectionReusableViewDelegate: AnyObject {
    func PlaylistCollectionReusableViewDidTapPlayAll(_ header: PlaylistCollectionReusableView)
}

class PlaylistCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "PlaylistCollectionReusableView"
    
    weak var delegate: PlaylistCollectionReusableViewDelegate?
    
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var labelDescriptionLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelDescriptionLabel.text = nil
        ownerNameLabel.text = nil
    }
    
    @IBAction func didTapPlayAll(_ sender: Any) {
        delegate?.PlaylistCollectionReusableViewDidTapPlayAll(self)
    }
    
    
    func configure(with viewModel: PlaylistHeaderViewModel){
        labelDescriptionLabel.text = viewModel.description
        ownerNameLabel.text = viewModel.ownerName
        playlistImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}
