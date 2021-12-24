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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureDetailsMovieCell(dataToDisplay: MovieCastResultsToSave) {
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 140, height: 210), scaleMode: .fill)
        
        self.detailsCollectionViewCellMainView.layer.backgroundColor = .init(genericCMYKCyan: 0.0, magenta: 0.0, yellow: 0, black: 0.0, alpha: 0)
        self.detailsCollectionViewCellMainView.layer.cornerRadius = 15
        self.detailsCollectionViewCellCastImage.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(dataToDisplay.profilePath)"), placeholderImage: nil, context: [.imageTransformer: transformer])
        self.detailsCollectionViewCellCastImage.layer.cornerRadius = 15
        self.detailsCollectionViewCellCastName.text = "\(dataToDisplay.name)"
    }
    
    func configureDetailsSeriesCell(dataToDisplay: TvCastResultsToSave) {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 140, height: 210), scaleMode: .fill)
        
        self.detailsCollectionViewCellMainView.layer.backgroundColor = .init(genericCMYKCyan: 0.0, magenta: 0.0, yellow: 0, black: 0.0, alpha: 0)
        self.detailsCollectionViewCellMainView.layer.cornerRadius = 15
        self.detailsCollectionViewCellCastImage.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(dataToDisplay.profilePath)"), placeholderImage: nil, context: [.imageTransformer: transformer])
        self.detailsCollectionViewCellCastImage.layer.cornerRadius = 15
        self.detailsCollectionViewCellCastName.text = "\(dataToDisplay.name)"
    }
}
