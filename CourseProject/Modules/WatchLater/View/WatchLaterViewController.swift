//
//  WatchLaterViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit

class WatchLaterViewController: UIViewController {
    
    var watchLaterViewModel = WatchLaterViewControllerViewModel()
    
    @IBOutlet weak var watchLaterCollectionView: UICollectionView!
    @IBOutlet weak var watchLaterSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        doStartupSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.layer.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        refreshWatchLaterList()
    }
    
    @IBAction func watchLaterSegmentedControlSwitched(_ sender: Any) {
        
        refreshWatchLaterList()
    }
    
    // MARK: - Private
    
    private func doStartupSetup() {
        
        watchLaterSegmentedControl.selectedSegmentIndex = 0
        watchLaterCollectionView.register(UINib(nibName: watchLaterCellName, bundle: nil),
                                          forCellWithReuseIdentifier: watchLaterCellName)
        self.title = watchLaterTitleString
        self.watchLaterCollectionView.layer.backgroundColor = transparentBackgroundColor
    }
    
    private func refreshWatchLaterList() {
        
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            watchLaterViewModel.getMoviesForWatchLater {
                self.watchLaterCollectionView.reloadData()
            }
            watchLaterViewModel.movieOrTvShow = 0
        } else {
            watchLaterViewModel.getTvShowsForWatchLater {
                self.watchLaterCollectionView.reloadData()
            }
            watchLaterViewModel.movieOrTvShow = 1
        }
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
        
        guard let watchLaterCell = watchLaterCollectionView.dequeueReusableCell(withReuseIdentifier: watchLaterCellName,
                                                                                for: indexPath) as? WatchLaterCollectionViewCell else { return UICollectionViewCell() }
        
        watchLaterCell.delegate = self
        watchLaterCell.indexForRemove = indexPath.row
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            var moviesDataToDisplay = MoviesResultsToSaveToWatchLater()
            moviesDataToDisplay = watchLaterViewModel.savedMoviesData[indexPath.row]
            watchLaterCell.configureMoviesCell(dataToDisplay: moviesDataToDisplay)
            watchLaterCell.movieOrTvShow = 0
        } else {
            var seriesDataToDisplay = TvResultsToSaveToWatchLater()
            seriesDataToDisplay = watchLaterViewModel.savedSeriesData[indexPath.row]
            watchLaterCell.configureSeriesCell(dataToDisplay: seriesDataToDisplay)
            watchLaterCell.movieOrTvShow = 1
        }
        return watchLaterCell
    }
}

extension WatchLaterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if watchLaterSegmentedControl.selectedSegmentIndex == 0 {
            let movieDataToDisplay = watchLaterViewModel.savedMoviesData[indexPath.row]
            let main = UIStoryboard(name: storyboardName, bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier:
                                                                            detailsViewControllerName)
                as? DetailsViewController {
                navigationController?.pushViewController(detailsViewController, animated: true)
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
            let tvDataToDisplay = watchLaterViewModel.savedSeriesData[indexPath.row]
            let main = UIStoryboard(name: storyboardName, bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier:
                                                                            detailsViewControllerName)
                as? DetailsViewController {
                navigationController?.pushViewController(detailsViewController, animated: true)
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

extension WatchLaterViewController: WatchLaterDeleteDelegate {
    
    func removeMovie(targetMovie: Int, indexForRemove: Int) {
        
        watchLaterViewModel.removeMovieFromWatchLater(targetMovie: targetMovie,
                                                          indexForRemove: indexForRemove)
        watchLaterCollectionView.reloadData()
    }
    
    func removeTvShow(targetTvShow: Int, indexForRemove: Int) {
        
        watchLaterViewModel.removeTvShowFromWatchLater(targetTvShow: targetTvShow,
                                                       indexForRemove: indexForRemove)
        watchLaterCollectionView.reloadData()
    }
}
