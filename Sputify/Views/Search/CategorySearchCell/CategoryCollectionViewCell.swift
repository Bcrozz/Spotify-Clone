//
//  CategoryCollectionViewCell.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"

    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemRed,
        .systemBlue,
        .systemBrown,
        .systemYellow,
        .systemGray,
        .systemOrange,
        .systemPurple,
        .systemTeal
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreNameLabel.text = nil
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel){
        genreNameLabel.text = viewModel.title
        categoryImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        categoryImageView.layer.cornerRadius = 10
        contentView.backgroundColor = colors.randomElement()
        contentView.layer.cornerRadius = 10
    }

}
