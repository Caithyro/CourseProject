//
//  ViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import Alamofire
import StatusAlert

class TrendingViewController: UIViewController {
    
    static let shared = TrendingViewController()
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var trendingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var trendingSearchBar: UISearchBar!
    @IBOutlet weak var saveMessageView: UIView!
    @IBOutlet weak var saveMessageLabel: UILabel!
    @IBOutlet weak var SaveMessageTopConstraint: NSLayoutConstraint!
    
    var savedMoviesArray : [MoviesResultsToSave] = []
    var savedSeriesArray : [TvResultsToSave] = []
    var searchPerformed: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        RequestManager.shared.trendingViewControllerInstance = self
        DetailsViewController.shared.trendingViewControllerInstance = self
        WatchLaterViewController.shared.trendingViewControllerInstance = self
        TrendingCollectionViewCell.shared.trendingViewControllerInstance = self
        DataManager.shared.trendingViewControllerInstance = self
        
        doStartupPreparations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.layer.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func displaySaveSuccessfullMessage() {
        
        let statusAlert = StatusAlert()
        
        statusAlert.appearance.backgroundColor = UIColor.systemGray2
        statusAlert.appearance.blurStyle = .regular
        statusAlert.alertShowingDuration = 1
        statusAlert.image = UIImage(systemName: "heart.fill")
        statusAlert.title = TrendingConstants.saveSuccessString
        statusAlert.message = ""
        statusAlert.canBePickedOrDismissed = true
        statusAlert.showInKeyWindow()
    }
    
    func displaySaveFailedMessage() {
        
        let statusAlert = StatusAlert()
        
        statusAlert.appearance.backgroundColor = UIColor.systemGray2
        statusAlert.appearance.blurStyle = .regular
        statusAlert.alertShowingDuration = 1
        statusAlert.image = UIImage(systemName: "heart.slash.fill")
        statusAlert.title = TrendingConstants.saveFailString
        statusAlert.message = ""
        statusAlert.canBePickedOrDismissed = true
        statusAlert.showInKeyWindow()
    }
    
    @IBAction func trendingSegmentedControlSwitched(_ sender: Any) {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            self.savedMoviesArray = DataManager.shared.getMoviesFromRealm()
            self.trendingCollectionView.reloadData()
            DetailsViewController.shared.movieOrTvShow = 0
            TrendingCollectionViewCell.shared.movieOrTvShow = 0
        } else {
            self.savedSeriesArray = DataManager.shared.getTvShowsFromRealm()
            self.trendingCollectionView.reloadData()
            DetailsViewController.shared.movieOrTvShow = 1
            TrendingCollectionViewCell.shared.movieOrTvShow = 1
        }
    }
    
    // MARK: - Private
    
    private func doStartupPreparations() {
        
        self.trendingCollectionView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.trendingCollectionView.register(UINib(nibName: "TrendingCollectionViewCell",
                                                   bundle: nil), forCellWithReuseIdentifier: "TrendingCollectionViewCell")
        trendingSegmentedControl.selectedSegmentIndex = 0
        TrendingCollectionViewCell.shared.movieOrTvShow = 0
        trendingSearchBar.showsCancelButton = false
        self.title = TrendingConstants.titleString
        RequestManager.shared.requestMovies()
        self.savedMoviesArray = DataManager.shared.getMoviesFromRealm()
        RequestManager.shared.requestTvShows()
        self.savedSeriesArray = DataManager.shared.getTvShowsFromRealm()
        self.trendingCollectionView.reloadData()
    }
}

// MARK: - Extensions

extension TrendingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            if searchPerformed == true {
                return RequestManager.shared.movieSearchResponceData.count
            } else {
                return savedMoviesArray.count
            }
        } else if trendingSegmentedControl.selectedSegmentIndex == 1 {
            if searchPerformed == true {
                return RequestManager.shared.tvSearchResponceData.count
            } else {
                return savedSeriesArray.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            if searchPerformed == true {
                guard let trendingCell = trendingCollectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell",
                                                                                    for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
                
                var moviesDataToDisplay = RequestManager.shared.movieSearchResponceData
                let eachSearchedMovie = moviesDataToDisplay[indexPath.row]
                trendingCell.configureMoviesSearchCell(dataToDisplay: eachSearchedMovie)
                for _ in moviesDataToDisplay {
                    moviesDataToDisplay.remove(at: 0)
                }
                return trendingCell
            } else {
                guard let trendingCell = trendingCollectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell",
                                                                                    for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
                
                var movieDataToDisplay = MoviesResultsToSave()
                var tvDataToDisplay = TvResultsToSave()
                
                if trendingSegmentedControl.selectedSegmentIndex == 0 {
                    movieDataToDisplay = savedMoviesArray[indexPath.row]
                    TrendingCollectionViewCell.shared.moviesData = movieDataToDisplay
                    trendingCell.configureMoviesCell(dataToDisplay: movieDataToDisplay)
                } else {
                    tvDataToDisplay = savedSeriesArray[indexPath.row]
                    trendingCell.configureSeriesCell(dataToDisplay: tvDataToDisplay)
                }
                return trendingCell
            }
        } else {
            if searchPerformed == true {
                guard let trendingCell = trendingCollectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell",
                                                                                    for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
                
                var tvDataToDisplay = RequestManager.shared.tvSearchResponceData
                let eachSearchedTvShow = tvDataToDisplay[indexPath.row]
                trendingCell.configureSeriesSearchCell(dataToDisplay: eachSearchedTvShow)
                for _ in tvDataToDisplay {
                    tvDataToDisplay.remove(at: 0)
                }
                
                return trendingCell
                
            } else {
                guard let trendingCell = trendingCollectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell",
                                                                                    for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
                
                var movieDataToDisplay = MoviesResultsToSave()
                var tvDataToDisplay = TvResultsToSave()
                
                if trendingSegmentedControl.selectedSegmentIndex == 0 {
                    movieDataToDisplay = savedMoviesArray[indexPath.row]
                    TrendingCollectionViewCell.shared.moviesData = movieDataToDisplay
                    trendingCell.configureMoviesCell(dataToDisplay: movieDataToDisplay)
                } else {
                    tvDataToDisplay = savedSeriesArray[indexPath.row]
                    trendingCell.configureSeriesCell(dataToDisplay: tvDataToDisplay)
                }
                return trendingCell
            }
        }
    }
}

extension TrendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            var movieDataToDisplay = MoviesResultsToSave()
            movieDataToDisplay = savedMoviesArray[indexPath.row]
            
            if searchPerformed == true {
                let movieRequestDataToDisplay = RequestManager.shared.movieSearchResponceData
                let eachSearchedMovie = movieRequestDataToDisplay[indexPath.row]
                let main = UIStoryboard(name: "Main", bundle: nil)
                if let detailsViewController = main.instantiateViewController(withIdentifier: "DetailsViewController")
                    as? DetailsViewController {
                    navigationController?.pushViewController(detailsViewController, animated: true)
                    RequestManager.shared.requestMovieCast(targetMovieId: eachSearchedMovie.id ?? 0)
                    RequestManager.shared.requestMovieTrailers(targetMovie: eachSearchedMovie.id ?? 0)
                    detailsViewController.backgroundImageViewURL = eachSearchedMovie.posterPath ?? ""
                    detailsViewController.detailsTitle = eachSearchedMovie.title ?? ""
                    detailsViewController.detailsPosterURL = eachSearchedMovie.posterPath ?? ""
                    detailsViewController.detailsDescription = eachSearchedMovie.overview ?? ""
                    detailsViewController.detailsAverageVote = eachSearchedMovie.voteAverage ?? 0.0
                    detailsViewController.detailsVoteCount = eachSearchedMovie.voteCount ?? 0
                    detailsViewController.detailsOriginalLanguage = eachSearchedMovie.originalLanguage ?? ""
                    detailsViewController.targetMovie = eachSearchedMovie.id ?? 0
                    detailsViewController.movieOrTvShow = 0
                }
            } else {
                let main = UIStoryboard(name: "Main", bundle: nil)
                if let detailsViewController = main.instantiateViewController(withIdentifier: "DetailsViewController")
                    as? DetailsViewController {
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
            }
        } else {
            var tvDataToDisplay = TvResultsToSave()
            tvDataToDisplay = savedSeriesArray[indexPath.row]
            if searchPerformed == true {
                let tvRequestDataToDisplay = RequestManager.shared.tvSearchResponceData
                let eachSearchedTvShow = tvRequestDataToDisplay[indexPath.row]
                let main = UIStoryboard(name: "Main", bundle: nil)
                if let detailsViewController = main.instantiateViewController(withIdentifier: "DetailsViewController")
                    as? DetailsViewController {
                    navigationController?.pushViewController(detailsViewController, animated: true)
                    RequestManager.shared.requestTvCast(targetShowId: eachSearchedTvShow.id ?? 0)
                    RequestManager.shared.requestTvTrailers(targetShow: eachSearchedTvShow.id ?? 0)
                    detailsViewController.backgroundImageViewURL = eachSearchedTvShow.posterPath ?? ""
                    detailsViewController.detailsTitle = eachSearchedTvShow.name ?? ""
                    detailsViewController.detailsPosterURL = eachSearchedTvShow.posterPath ?? ""
                    detailsViewController.detailsDescription = eachSearchedTvShow.overview ?? ""
                    detailsViewController.detailsAverageVote = eachSearchedTvShow.voteAverage ?? 0.0
                    detailsViewController.detailsVoteCount = eachSearchedTvShow.voteCount ?? 0
                    detailsViewController.detailsOriginalLanguage = eachSearchedTvShow.originalLanguage ?? ""
                    detailsViewController.targetTvShow = eachSearchedTvShow.id ?? 0
                    detailsViewController.movieOrTvShow = 1
                }
            } else {
                let main = UIStoryboard(name: "Main", bundle: nil)
                if let detailsViewController = main.instantiateViewController(withIdentifier: "DetailsViewController")
                    as? DetailsViewController {
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
}

extension TrendingViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            RequestManager.shared.movieSearchRequest(query: trendingSearchBar.text ?? "")
            searchPerformed = true
            TrendingCollectionViewCell.shared.searchPerformed = true
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
        } else {
            RequestManager.shared.tvSearchRequest(query: trendingSearchBar.text ?? "")
            searchPerformed = true
            TrendingCollectionViewCell.shared.searchPerformed = true
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchPerformed = false
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        TrendingCollectionViewCell.shared.searchPerformed = false
        trendingCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            
            if self.trendingSegmentedControl.selectedSegmentIndex == 0 {
                RequestManager.shared.movieSearchRequest(query: self.trendingSearchBar.text ?? "")
                self.searchPerformed = true
                TrendingCollectionViewCell.shared.searchPerformed = true
            } else {
                RequestManager.shared.tvSearchRequest(query: self.trendingSearchBar.text ?? "")
                self.searchPerformed = true
                TrendingCollectionViewCell.shared.searchPerformed = true
            }
        }
    }
}

struct TrendingConstants {
    
    static let saveSuccessString = "Saved succesfully"
    static let saveFailString = "Save failed"
    static let titleString = "Trending for today"
}
