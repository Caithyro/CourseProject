//
//  DetailsViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import SDWebImage
import RealmSwift
import youtube_ios_player_helper

class DetailsViewController: UIViewController {
    
    static let shared = DetailsViewController()
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
        
        RequestManager.shared.detailsViewControllerInstance = self
        
        detailsCastCollectionView!.register(UINib(nibName: DetailsConstants.cellName, bundle: nil),
                                            forCellWithReuseIdentifier: DetailsConstants.cellName)
        setBackgroundImage()
        setPosterImage()
        setLabelsTexts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.layer.isHidden = true
        detailsViewModel.loadTrailersAndCast(movieOrTvShow: self.detailsViewModel.movieOrTvShow,
                                             targetMovie: self.detailsViewModel.targetMovie, targetTvShow: self.detailsViewModel.targetTvShow, completion: {
            self.detailsCastCollectionView.reloadData()
            self.detailsPlayerView.load(withVideoId: self.detailsViewModel.videoId)
        })
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
        
        self.detailsScrollView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.detailsMainView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.detailsBackgroundImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(detailsViewModel.backgroundImageViewURL)"),
                                                    placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformerForBackground])
        applyBlur(imageView: detailsBackgroundImageView)
    }
    
    private func setPosterImage() {
        
        self.detailsPosterImageView.layer.cornerRadius = 25
        self.detailsPosterImageView.sd_setImage(with: URL(string: "https://www.themoviedb.org/t/p/original\(detailsViewModel.detailsPosterURL)"),
                                                placeholderImage: UIImage(named: "empty"), context: [.imageTransformer: transformerForPoster])
    }
    
    private func setLabelsTexts() {
        
        let languagesDictionary = detailsViewModel.originalLanguages
        self.detailsTitleLabel.text = detailsViewModel.detailsTitle
        self.detailsDescriptionLabel.text = detailsViewModel.detailsDescription
        self.detailsAverageVoteLabel.text = "\(DetailsConstants.averageRateString) \(detailsViewModel.detailsAverageVote) \(DetailsConstants.inString) \(detailsViewModel.detailsVoteCount) \(DetailsConstants.votesString)"
        self.detailsLanguageLabel.text = "\(DetailsConstants.originalLanguageString) \(languagesDictionary[detailsViewModel.detailsOriginalLanguage] ?? "\(DetailsConstants.unknownString)")"
        self.detailsCastCollectionView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
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
        
        guard let detailsCell = detailsCastCollectionView.dequeueReusableCell(withReuseIdentifier: DetailsConstants.cellName,
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
