//
//  DetailsViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import SDWebImage
import RealmSwift

class DetailsViewController: UIViewController {
    
    var backgroundImageViewURL: String = ""
    var detailsTitle: String = ""
    var detailsPosterURL: String = ""
    var detailsDescription: String = ""
    var detailsAverageVote: Double = 0.0
    var detailsVoteCount: Int = 0
    var detailsGenres: List<Genres>? = nil
    var detailsOriginalLanguage: String = ""
    
    let transformerForBackground = SDImageResizingTransformer(size: CGSize(width: 414, height: 896), scaleMode: .fill)
    let transformerForPoster = SDImageResizingTransformer(size: CGSize(width: 300, height: 450), scaleMode: .fill)
    
    @IBOutlet weak var detailsBackgroundImageView: UIImageView!
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsPosterImageView: UIImageView!
    @IBOutlet weak var detailsDescriptionLabel: UILabel!
    @IBOutlet weak var detailsAverageVoteLabel: UILabel!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var detailsMainView: UIView!
    @IBOutlet weak var detailsLanguageLabel: UILabel!
    @IBOutlet weak var detailsCastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsCastCollectionView.register(UINib(nibName: "DetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailsCollectionViewCell")
        
        self.detailsScrollView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.detailsMainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.detailsBackgroundImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(backgroundImageViewURL)"), placeholderImage: nil, context: [.imageTransformer: transformerForBackground])
        blur(imageView: detailsBackgroundImageView)
        self.detailsTitleLabel.text = detailsTitle
        self.detailsPosterImageView.layer.cornerRadius = 25
        self.detailsPosterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(detailsPosterURL)"), placeholderImage: nil, context: [.imageTransformer: transformerForPoster])
        self.detailsDescriptionLabel.text = detailsDescription
        self.detailsAverageVoteLabel.text = "Average rate - \(detailsAverageVote) in \(detailsVoteCount) votes"
        if detailsOriginalLanguage == "en" {
            detailsLanguageLabel.text = "Original language: English"
        } else if detailsOriginalLanguage == "es" {
            detailsLanguageLabel.text = "Original language: Spanish"
        } else if detailsOriginalLanguage == "ru" {
            detailsLanguageLabel.text = "Original language: Russian"
        } else {
            detailsLanguageLabel.text = detailsOriginalLanguage
        }
        self.detailsCastCollectionView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.layer.isHidden = true
    }
    
    func blur(imageView: UIImageView) {
        let regularBlur = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurView = UIVisualEffectView(effect: regularBlur)
        blurView.frame = imageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurView)
    }
    
}

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let detailsCell = detailsCastCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as? DetailsCollectionViewCell else { return UICollectionViewCell() }
        
        detailsCell.configureDetailsCell()
        
        return detailsCell
    }
    
    
}
