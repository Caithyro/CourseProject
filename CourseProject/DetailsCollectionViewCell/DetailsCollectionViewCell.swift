//
//  DetailsCollectionViewCell.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 24.12.2021.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var detailsCollectionViewCellMainView: UIView!
    @IBOutlet weak var detailsCollectionViewCellCastImage: UIImageView!
    @IBOutlet weak var detailsCollectionViewCellCastName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureDetailsCell() {
    self.detailsCollectionViewCellMainView.layer.backgroundColor = .init(genericCMYKCyan: 0.0, magenta: 0.0, yellow: 1.0, black: 0.0, alpha: 1.0)
        self.detailsCollectionViewCellMainView.layer.cornerRadius = 15
    }
}
