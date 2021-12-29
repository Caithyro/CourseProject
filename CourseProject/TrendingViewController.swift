//
//  ViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import Alamofire

class TrendingViewController: UIViewController {
    
    static let shared = TrendingViewController()
    
    @IBOutlet weak var TrendingCollectionView: UICollectionView!
    @IBOutlet weak var trendingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var trendingSearchBar: UISearchBar!
    @IBOutlet weak var saveMessageView: UIView!
    @IBOutlet weak var saveMessageLabel: UILabel!
    @IBOutlet weak var SaveMessageTopConstraint: NSLayoutConstraint!
    
    var savedMoviesArray : [MoviesResultsToSave] = []
    var savedSeriesArray : [TvResultsToSave] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RequestManager.shared.trendingViewControllerInstance = self
        DetailsViewController.shared.trendingViewControllerInstance = self
        WatchLaterViewController.shared.trendingViewControllerInstance = self
        TrendingCollectionViewCell.shared.trendingViewControllerInstance = self
        DataManager.shared.trendingViewControllerInstance = self
        
        trendingSegmentedControl.selectedSegmentIndex = 0
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            RequestManager.shared.requestMovies()
            self.savedMoviesArray = DataManager.shared.getMovies()
            RequestManager.shared.requestTvShows()
            self.savedSeriesArray = DataManager.shared.getSeries()
            self.TrendingCollectionView.reloadData()
        }
        
        self.TrendingCollectionView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.TrendingCollectionView.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TrendingCollectionViewCell")
        self.title = "Trending for today"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.layer.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func saveSuccessfull() {
        self.saveMessageLabel.text = "Saved succesfully!"
        self.saveMessageView.layer.cornerRadius = 15
        self.saveMessageView.layer.backgroundColor = CGColor(genericCMYKCyan: 0.26, magenta: 0.2, yellow: 0.22, black: 0.2, alpha: 0.7)
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse]) {
            self.SaveMessageTopConstraint.constant = -16
            self.view.layoutIfNeeded()
        } completion: { (finished: Bool) in
            self.SaveMessageTopConstraint.constant = 200
        }
    }
    
    func saveFailed() {
        self.saveMessageLabel.text = "Save failed!"
        self.saveMessageView.layer.cornerRadius = 15
        self.saveMessageView.layer.backgroundColor = CGColor(genericCMYKCyan: 0.26, magenta: 0.2, yellow: 0.22, black: 0.2, alpha: 0.7)
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse]) {
            self.SaveMessageTopConstraint.constant = -16
            self.view.layoutIfNeeded()
        } completion: { (finished: Bool) in
            self.SaveMessageTopConstraint.constant = 200
        }
    }
    
    @IBAction func trendingSegmentedControlSwitched(_ sender: Any) {
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            self.savedMoviesArray = DataManager.shared.getMovies()
            self.TrendingCollectionView.reloadData()
            DetailsViewController.shared.movieOrTvShow = 0
        } else {
            self.savedSeriesArray = DataManager.shared.getSeries()
            self.TrendingCollectionView.reloadData()
            DetailsViewController.shared.movieOrTvShow = 1
        }
    }
}

extension TrendingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            if trendingSegmentedControl.selectedSegmentIndex == 0 {
                return savedMoviesArray.count
            } else if trendingSegmentedControl.selectedSegmentIndex == 1 {
                return savedSeriesArray.count
            } else {
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let trendingCell = TrendingCollectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
        
        var movieDataToDisplay = MoviesResultsToSave()
        var tvDataToDisplay = TvResultsToSave()
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            movieDataToDisplay = savedMoviesArray[indexPath.row]
            TrendingCollectionViewCell.shared.moviesData = movieDataToDisplay
            trendingCell.configureMoviesCell(dataToDisplay: movieDataToDisplay)
        } else if trendingSegmentedControl.selectedSegmentIndex == 1 {
            tvDataToDisplay = savedSeriesArray[indexPath.row]
            trendingCell.configureSeriesCell(dataToDisplay: tvDataToDisplay)
        }
        
        return trendingCell
    }
    
    
}

extension TrendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var movieDataToDisplay = MoviesResultsToSave()
        var tvDataToDisplay = TvResultsToSave()
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            movieDataToDisplay = savedMoviesArray[indexPath.row]
            let main = UIStoryboard(name: "Main", bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                navigationController?.pushViewController(detailsViewController, animated: true)
                RequestManager.shared.requestMovieCast(targetMovieId: movieDataToDisplay.id)
                RequestManager.shared.requestMovieTrailers(targetMovie: movieDataToDisplay.id)
                detailsViewController.backgroundImageViewURL = movieDataToDisplay.posterPath
                detailsViewController.detailsTitle = movieDataToDisplay.title
                detailsViewController.detailsPosterURL = movieDataToDisplay.posterPath
                detailsViewController.detailsDescription = movieDataToDisplay.overview
                detailsViewController.detailsAverageVote = movieDataToDisplay.voteAverage
                detailsViewController.detailsVoteCount = movieDataToDisplay.voteCount
                detailsViewController.detailsOriginalLanguage = movieDataToDisplay.originalLanguage
                detailsViewController.targetMovie = movieDataToDisplay.id
                detailsViewController.movieOrTvShow = 0
            }
        } else if trendingSegmentedControl.selectedSegmentIndex == 1 {
            tvDataToDisplay = savedSeriesArray[indexPath.row]
            let main = UIStoryboard(name: "Main", bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                navigationController?.pushViewController(detailsViewController, animated: true)
                RequestManager.shared.requestTvCast(targetShowId: tvDataToDisplay.id)
                RequestManager.shared.requestTvTrailers(targetShow: tvDataToDisplay.id)
                detailsViewController.backgroundImageViewURL = tvDataToDisplay.posterPath
                detailsViewController.detailsTitle = tvDataToDisplay.name
                detailsViewController.detailsPosterURL = tvDataToDisplay.posterPath
                detailsViewController.detailsDescription = tvDataToDisplay.overview
                detailsViewController.detailsAverageVote = tvDataToDisplay.voteAverage
                detailsViewController.detailsVoteCount = tvDataToDisplay.voteCount
                detailsViewController.detailsOriginalLanguage = tvDataToDisplay.originalLanguage
                detailsViewController.targetTvShow = tvDataToDisplay.id
                detailsViewController.movieOrTvShow = 1
            }
        }
    }
}

