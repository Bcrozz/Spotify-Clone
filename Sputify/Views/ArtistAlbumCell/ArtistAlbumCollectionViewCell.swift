//
//  ArtistAlbumCollectionViewCell.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 16/11/21.
//

import UIKit
import SDWebImage

class ArtistAlbumCollectionViewCell: UICollectionViewCell {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static let identifier = "ArtistAlbumCollectionViewCell"
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumTypeAndDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        albumTypeAndDateLabel.text = nil
    }
    
    func configure(with viewModel: ArtistAlbumCellViewModel){
        albumNameLabel.text = viewModel.name ?? ""
//        let yearDate = dateFormatter.date(from: viewModel.releaseYear ?? "2021")
//        let yearString = dateFormatter.string(from: yearDate!)
        albumTypeAndDateLabel.text = "\(viewModel.releaseYear ?? "2021")•\(viewModel.albumType ?? "Album")"
        albumImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
}
