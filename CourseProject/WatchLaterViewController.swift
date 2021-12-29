//
//  WatchLaterViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit

class WatchLaterViewController: UIViewController {
    
    static let shared = WatchLaterViewController()
    weak var trendingViewControllerInstance = TrendingViewController()
    
    var savedMoviesData: [MoviesResultsToSaveToWatchLater] = []
    var savedSeriesData: [TvResultsToSaveToWatchLater] = []
    
    @IBOutlet weak var watchLaterCollectionView: UICollectionView!
    @IBOutlet weak var watchLaterSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.watchLaterViewControllerInstance = self
        
        watchLaterSegmentedControl.selectedSegmentIndex = 0
        watchLaterCollectionView.register(UINib(nibName: "WatchLaterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WatchLaterCollectionViewCell")
        
        self.title = "Watch Later"
        
        self.watchLaterCollectionView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.savedMoviesData = DataManager.shared.getMoviesWatchLaterList()
        self.savedSeriesData = DataManager.shared.getTvWatchLaterList()
        self.watchLaterCollectionView.reloadData()
        
        self.tabBarController?.tabBar.layer.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func watchLaterSegmentedControlSwitched(_ sender: Any) {
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            self.savedMoviesData = DataManager.shared.getMoviesWatchLaterList()
            self.watchLaterCollectionView.reloadData()
            DetailsViewController.shared.movieOrTvShow = 0
        } else {
            self.savedSeriesData = DataManager.shared.getTvWatchLaterList()
            self.watchLaterCollectionView.reloadData()
            DetailsViewController.shared.movieOrTvShow = 1
        }
    }
    
}

extension WatchLaterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            return savedMoviesData.count
        } else if watchLaterSegmentedControl.selectedSegmentIndex == 1 {
            return savedSeriesData.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let watchLaterCell = watchLaterCollectionView.dequeueReusableCell(withReuseIdentifier: "WatchLaterCollectionViewCell", for: indexPath) as? WatchLaterCollectionViewCell else { return UICollectionViewCell() }
        
        var moviesDataToDisplay = MoviesResultsToSaveToWatchLater()
        var seriesDataToDisplay = TvResultsToSaveToWatchLater()
        
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            moviesDataToDisplay = savedMoviesData[indexPath.row]
            watchLaterCell.configureMoviesCell(dataToDisplay: moviesDataToDisplay)
        } else {
            seriesDataToDisplay = savedSeriesData[indexPath.row]
            watchLaterCell.configureSeriesCell(dataToDisplay: seriesDataToDisplay)
        }
        
        return watchLaterCell
    }
}

extension WatchLaterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var movieDataToDisplay = MoviesResultsToSaveToWatchLater()
        var tvDataToDisplay = TvResultsToSaveToWatchLater()
        
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            movieDataToDisplay = savedMoviesData[indexPath.row]
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
        } else if watchLaterSegmentedControl.selectedSegmentIndex == 1 {
            tvDataToDisplay = savedSeriesData[indexPath.row]
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
