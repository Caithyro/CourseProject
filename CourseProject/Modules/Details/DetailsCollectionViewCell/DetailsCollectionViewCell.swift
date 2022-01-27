//
//  DetailsCollectionViewCell.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 24.12.2021.
//

import UIKit
import SDWebImage

class DetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailsCollectionViewCellMainView: UIView!
    @IBOutlet weak var detailsCollectionViewCellCastImage: UIImageView!
    @IBOutlet weak var detailsCollectionViewCellCastName: UILabel!
    
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 140, height: 210), scaleMode: .fill)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureDetailsMovieCell(dataToDisplay: MovieCastResultsToSave) {
        
        let profileImageUrlString = "\(imageUrlString)\(dataToDisplay.profilePath)"
        self.detailsCollectionViewCellMainView.layer.backgroundColor = transparentBackgroundColor
        self.detailsCollectionViewCellMainView.layer.cornerRadius = 15
        self.detailsCollectionViewCellCastImage.sd_setImage(with: URL(string: profileImageUrlString),
                                                            placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.detailsCollectionViewCellCastImage.layer.cornerRadius = 15
        self.detailsCollectionViewCellCastName.text = "\(dataToDisplay.name)"
    }
    
    func configureDetailsSeriesCell(dataToDisplay: TvCastResultsToSave) {
        
        let profileImageUrlString = "\(imageUrlString)\(dataToDisplay.profilePath)"
        self.detailsCollectionViewCellMainView.layer.backgroundColor = transparentBackgroundColor
        self.detailsCollectionViewCellMainView.layer.cornerRadius = 15
        self.detailsCollectionViewCellCastImage.sd_setImage(with: URL(string: profileImageUrlString),
                                                            placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformer])
        self.detailsCollectionViewCellCastImage.layer.cornerRadius = 15
        self.detailsCollectionViewCellCastName.text = "\(dataToDisplay.name)"
    }
}
