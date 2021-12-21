//
//  TrendingCollectionViewCell.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var someView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell() {
        self.someView.layer.backgroundColor = .init(genericCMYKCyan: 2.2, magenta: 0.0, yellow: 0.0, black: 0.0, alpha: 1)
    }
    
}
