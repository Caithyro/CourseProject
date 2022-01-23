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
    var watchLaterViewModel = WatchLaterViewControllerViewModel()
    
    @IBOutlet weak var watchLaterCollectionView: UICollectionView!
    @IBOutlet weak var watchLaterSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        DataManager.shared.watchLaterViewControllerInstance = self
        doStartupSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        watchLaterViewModel.getMediaDataFromRealm {
            self.watchLaterCollectionView.reloadData()
        }
        self.tabBarController?.tabBar.layer.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func watchLaterSegmentedControlSwitched(_ sender: Any) {
        
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            watchLaterViewModel.getMoviesFromWatchLater {
                self.watchLaterCollectionView.reloadData()
                DetailsViewController.shared.detailsViewModel.movieOrTvShow = 0
                WatchLaterCollectionViewCell.shared.movieOrTvShow = 0
            }
        } else {
            watchLaterViewModel.getTvShowsFromWatchLater {
                self.watchLaterCollectionView.reloadData()
                DetailsViewController.shared.detailsViewModel.movieOrTvShow = 1
                WatchLaterCollectionViewCell.shared.movieOrTvShow = 1
            }
        }
    }
    
    // MARK: - Private
    
    private func doStartupSetup() {
        
        watchLaterSegmentedControl.selectedSegmentIndex = 0
        watchLaterCollectionView.register(UINib(nibName: WatchLaterConstants.cellName, bundle: nil),
                                          forCellWithReuseIdentifier: WatchLaterConstants.cellName)
        self.title = WatchLaterConstants.titleString
        self.watchLaterCollectionView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0,
                                                                      yellow: 0, black: 0, alpha: 0)
    }
}

// MARK: - Extensions

extension WatchLaterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            return watchLaterViewModel.savedMoviesData.count
        } else if watchLaterSegmentedControl.selectedSegmentIndex == 1 {
            return watchLaterViewModel.savedSeriesData.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let watchLaterCell = watchLaterCollectionView.dequeueReusableCell(withReuseIdentifier: WatchLaterConstants.cellName,
                                                                                for: indexPath) as? WatchLaterCollectionViewCell else { return UICollectionViewCell() }
        
        var moviesDataToDisplay = MoviesResultsToSaveToWatchLater()
        var seriesDataToDisplay = TvResultsToSaveToWatchLater()
        
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            moviesDataToDisplay = watchLaterViewModel.savedMoviesData[indexPath.row]
            watchLaterCell.configureMoviesCell(dataToDisplay: moviesDataToDisplay)
        } else {
            seriesDataToDisplay = watchLaterViewModel.savedSeriesData[indexPath.row]
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
            movieDataToDisplay = watchLaterViewModel.savedMoviesData[indexPath.row]
            let main = UIStoryboard(name: WatchLaterConstants.storyboardName, bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier:
                                                                            WatchLaterConstants.viewControllerName)
                as? DetailsViewController {
                navigationController?.pushViewController(detailsViewController, animated: true)
                RequestManager.shared.requestMovieCast(targetMovieId: movieDataToDisplay.id)
                RequestManager.shared.requestMovieTrailers(targetMovie: movieDataToDisplay.id)
                detailsViewController.detailsViewModel.backgroundImageViewURL = movieDataToDisplay.posterPath
                detailsViewController.detailsViewModel.detailsTitle = movieDataToDisplay.title
                detailsViewController.detailsViewModel.detailsPosterURL = movieDataToDisplay.posterPath
                detailsViewController.detailsViewModel.detailsDescription = movieDataToDisplay.overview
                detailsViewController.detailsViewModel.detailsAverageVote = movieDataToDisplay.voteAverage
                detailsViewController.detailsViewModel.detailsVoteCount = movieDataToDisplay.voteCount
                detailsViewController.detailsViewModel.detailsOriginalLanguage = movieDataToDisplay.originalLanguage
                detailsViewController.detailsViewModel.targetMovie = movieDataToDisplay.id
                detailsViewController.detailsViewModel.movieOrTvShow = 0
            }
        } else if watchLaterSegmentedControl.selectedSegmentIndex == 1 {
            tvDataToDisplay = watchLaterViewModel.savedSeriesData[indexPath.row]
            let main = UIStoryboard(name: WatchLaterConstants.storyboardName, bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier:
                                                                            WatchLaterConstants.viewControllerName)
                as? DetailsViewController {
                navigationController?.pushViewController(detailsViewController, animated: true)
                RequestManager.shared.requestTvCast(targetShowId: tvDataToDisplay.id)
                RequestManager.shared.requestTvTrailers(targetShow: tvDataToDisplay.id)
                detailsViewController.detailsViewModel.backgroundImageViewURL = tvDataToDisplay.posterPath
                detailsViewController.detailsViewModel.detailsTitle = tvDataToDisplay.name
                detailsViewController.detailsViewModel.detailsPosterURL = tvDataToDisplay.posterPath
                detailsViewController.detailsViewModel.detailsDescription = tvDataToDisplay.overview
                detailsViewController.detailsViewModel.detailsAverageVote = tvDataToDisplay.voteAverage
                detailsViewController.detailsViewModel.detailsVoteCount = tvDataToDisplay.voteCount
                detailsViewController.detailsViewModel.detailsOriginalLanguage = tvDataToDisplay.originalLanguage
                detailsViewController.detailsViewModel.targetTvShow = tvDataToDisplay.id
                detailsViewController.detailsViewModel.movieOrTvShow = 1
            }
        }
    }
}
