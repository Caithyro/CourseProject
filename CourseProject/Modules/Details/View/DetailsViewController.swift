//
//  DetailsViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class DetailsViewController: UIViewController {
    
    var detailsViewModel = DetailsViewControllerViewModel()
    
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
    @IBOutlet weak var detailsPlayerView: YTPlayerView!
    @IBOutlet weak var videoNotFoundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsCastCollectionView!.register(UINib(nibName: detailsCellName, bundle: nil),
                                            forCellWithReuseIdentifier: detailsCellName)
        setBackgroundImage()
        setPosterImage()
        setLabelsTexts()
        detailsViewModel.loadTrailersAndCast(movieOrTvShow: self.detailsViewModel.movieOrTvShow,
                                             targetMovie: self.detailsViewModel.targetMovie, targetTvShow: self.detailsViewModel.targetTvShow, completion: {
            self.detailsCastCollectionView.reloadData()
            self.detailsPlayerView.load(withVideoId: self.detailsViewModel.videoId)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.layer.isHidden = true
    }
    
    //MARK: - Private
    
    private func applyBlur(imageView: UIImageView) {
        
        let regularBlur = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurView = UIVisualEffectView(effect: regularBlur)
        blurView.frame = imageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurView)
    }
    
    private func setBackgroundImage() {
        
        let backgroundImageUrlString = "\(imageUrlString)\(detailsViewModel.backgroundImageViewURL)"
        self.detailsScrollView.layer.backgroundColor = transparentBackgroundColor
        self.detailsMainView.layer.backgroundColor = transparentBackgroundColor
        self.detailsBackgroundImageView.sd_setImage(with: URL(string: backgroundImageUrlString),
                                                    placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformerForBackground])
        applyBlur(imageView: detailsBackgroundImageView)
    }
    
    private func setPosterImage() {
        
        let posterImageUrlString = "\(imageUrlString)\(detailsViewModel.detailsPosterURL)"
        self.detailsPosterImageView.layer.cornerRadius = 25
        self.detailsPosterImageView.sd_setImage(with: URL(string: posterImageUrlString),
                                                placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformerForPoster])
    }
    
    private func setLabelsTexts() {
        
        self.detailsTitleLabel.text = detailsViewModel.detailsTitle
        self.detailsDescriptionLabel.text = detailsViewModel.detailsDescription
        self.detailsAverageVoteLabel.text = "\(detailsAverageRateString) \(detailsViewModel.detailsAverageVote) \(detailsInString) \(detailsViewModel.detailsVoteCount) \(detailsVotesString)"
        self.detailsLanguageLabel.text = "\(originalLanguageString) \(originalLanguages[detailsViewModel.detailsOriginalLanguage] ?? "\(detailsUnknownString)")"
        self.detailsCastCollectionView.layer.backgroundColor = transparentBackgroundColor
    }
}

//MARK: - Extensions

extension DetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if detailsViewModel.movieOrTvShow == 0 {
            return detailsViewModel.savedMovieCast.count > 5 ? 5 : detailsViewModel.savedMovieCast.count
        } else {
            return detailsViewModel.savedTvCast.count > 5 ? 5 : detailsViewModel.savedTvCast.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let detailsCell = detailsCastCollectionView.dequeueReusableCell(withReuseIdentifier: detailsCellName,
                                                                              for: indexPath) as? DetailsCollectionViewCell else { return UICollectionViewCell() }
        if detailsViewModel.movieOrTvShow == 0 {
            var dataToDisplay = MovieCastResultsToSave()
            
            dataToDisplay = detailsViewModel.savedMovieCast[indexPath.row]
            detailsCell.configureDetailsMovieCell(dataToDisplay: dataToDisplay)
            
            return detailsCell
        } else {
            var dataToDisplay = TvCastResultsToSave()
            
            dataToDisplay = detailsViewModel.savedTvCast[indexPath.row]
            detailsCell.configureDetailsSeriesCell(dataToDisplay: dataToDisplay)
            
            return detailsCell
        }
    }
}
