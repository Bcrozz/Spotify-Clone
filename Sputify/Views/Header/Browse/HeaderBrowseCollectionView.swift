//
//  HeaderBrowseCollectionView.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 14/11/21.
//

import UIKit

class HeaderBrowseCollectionView: UICollectionReusableView {
    
    static let identifier = "HeaderBrowseCollectionView"
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = nil
    }
    
}
