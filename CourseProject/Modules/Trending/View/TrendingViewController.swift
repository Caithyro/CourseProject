//
//  ViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import StatusAlert

class TrendingViewController: UIViewController {
    
    static let shared = TrendingViewController()
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var trendingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var trendingSearchBar: UISearchBar!
    
    var trendingViewModel = TrendingViewControllerViewModel()
    var searchPerformed: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        RequestManager.shared.trendingViewControllerInstance = self
        WatchLaterViewController.shared.trendingViewControllerInstance = self
        TrendingCollectionViewCell.shared.trendingViewControllerInstance = self
        DataManager.shared.trendingViewControllerInstance = self
        
        doStartupSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.layer.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func displaySaveStatusAlert(saveSuccess: Bool) {
        
        let statusAlert = StatusAlert()
        statusAlert.appearance.backgroundColor = UIColor.systemGray2
        statusAlert.appearance.blurStyle = .regular
        statusAlert.alertShowingDuration = TrendingConstants.alertShowingDuration
        statusAlert.canBePickedOrDismissed = true
        if saveSuccess == true {
            statusAlert.image = UIImage(systemName: "heart.fill")
            statusAlert.title = TrendingConstants.saveSuccessString
            statusAlert.message = ""
            statusAlert.showInKeyWindow()
        } else {
            statusAlert.image = UIImage(systemName: "heart.slash.fill")
            statusAlert.title = TrendingConstants.saveFailString
            statusAlert.message = ""
            statusAlert.showInKeyWindow()
        }
    }
    
    @IBAction func trendingSegmentedControlSwitched(_ sender: Any) {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            trendingViewModel.loadMovies(searchPerformed: self.searchPerformed,
                                         query: self.trendingSearchBar.text ?? "")
            DetailsViewController.shared.detailsViewModel.movieOrTvShow = 0
            TrendingCollectionViewCell.shared.movieOrTvShow = 0
        } else {
            trendingViewModel.loadTvShows(searchPerformed: self.searchPerformed,
                                          query: self.trendingSearchBar.text ?? "")
            DetailsViewController.shared.detailsViewModel.movieOrTvShow = 1
            TrendingCollectionViewCell.shared.movieOrTvShow = 1
        }
    }
    
    // MARK: - Private
    
    private func doStartupSetup() {
        
        self.trendingCollectionView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0,
                                                                    yellow: 0, black: 0, alpha: 0)
        self.trendingCollectionView.register(UINib(nibName: TrendingConstants.cellName,
                                                   bundle: nil), forCellWithReuseIdentifier: TrendingConstants.cellName)
        trendingSegmentedControl.selectedSegmentIndex = 0
        TrendingCollectionViewCell.shared.movieOrTvShow = 0
        trendingSearchBar.showsCancelButton = false
        self.title = TrendingConstants.titleString
        trendingViewModel.loadMovies(searchPerformed: self.searchPerformed, query: "")
        trendingViewModel.loadTvShows(searchPerformed: self.searchPerformed, query: "")
    }
}

// MARK: - Extensions

extension TrendingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            return RequestManager.shared.moviesResponceData.count
        } else {
            return RequestManager.shared.tvShowsResponceData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            
            guard let trendingCell = trendingCollectionView.dequeueReusableCell(withReuseIdentifier: TrendingConstants.cellName,
                                                                                for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
            
            var moviesDataToDisplay = RequestManager.shared.moviesResponceData
            let eachSearchedMovie = moviesDataToDisplay[indexPath.row]
            trendingCell.configureMoviesCell(dataToDisplay: eachSearchedMovie)
            for _ in moviesDataToDisplay {
                moviesDataToDisplay.remove(at: 0)
            }
            return trendingCell
        } else {
            guard let trendingCell = trendingCollectionView.dequeueReusableCell(withReuseIdentifier: TrendingConstants.cellName,
                                                                                for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
            
            var tvDataToDisplay = RequestManager.shared.tvShowsResponceData
            let eachSearchedTvShow = tvDataToDisplay[indexPath.row]
            trendingCell.configureSeriesCell(dataToDisplay: eachSearchedTvShow)
            for _ in tvDataToDisplay {
                tvDataToDisplay.remove(at: 0)
            }
            return trendingCell
        }
    }
}

extension TrendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            let movieDataToDisplay = RequestManager.shared.moviesResponceData[indexPath.row]
            let main = UIStoryboard(name: TrendingConstants.storyboardName, bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier:
                                                                            TrendingConstants.viewControllerName)
                as? DetailsViewController {
                navigationController?.pushViewController(detailsViewController, animated: true)
                detailsViewController.detailsViewModel.backgroundImageViewURL = movieDataToDisplay.backdropPath ?? ""
                detailsViewController.detailsViewModel.detailsTitle = movieDataToDisplay.title ?? ""
                detailsViewController.detailsViewModel.detailsPosterURL = movieDataToDisplay.posterPath ?? ""
                detailsViewController.detailsViewModel.detailsDescription = movieDataToDisplay.overview ?? ""
                detailsViewController.detailsViewModel.detailsAverageVote = movieDataToDisplay.voteAverage ?? 0.0
                detailsViewController.detailsViewModel.detailsVoteCount = movieDataToDisplay.voteCount ?? 0
                detailsViewController.detailsViewModel.detailsOriginalLanguage = movieDataToDisplay.originalLanguage ?? ""
                detailsViewController.detailsViewModel.targetMovie = movieDataToDisplay.id ?? 0
                detailsViewController.detailsViewModel.movieOrTvShow = 0
            }
        } else {
            let tvDataToDisplay = RequestManager.shared.tvShowsResponceData[indexPath.row]
            let main = UIStoryboard(name: TrendingConstants.storyboardName, bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier:
                                                                            TrendingConstants.viewControllerName)
                as? DetailsViewController {
                navigationController?.pushViewController(detailsViewController, animated: true)
                detailsViewController.detailsViewModel.backgroundImageViewURL = tvDataToDisplay.posterPath ?? ""
                detailsViewController.detailsViewModel.detailsTitle = tvDataToDisplay.name ?? ""
                detailsViewController.detailsViewModel.detailsPosterURL = tvDataToDisplay.posterPath ?? ""
                detailsViewController.detailsViewModel.detailsDescription = tvDataToDisplay.overview ?? ""
                detailsViewController.detailsViewModel.detailsAverageVote = tvDataToDisplay.voteAverage ?? 0.0
                detailsViewController.detailsViewModel.detailsVoteCount = tvDataToDisplay.voteCount ?? 0
                detailsViewController.detailsViewModel.detailsOriginalLanguage = tvDataToDisplay.originalLanguage ?? ""
                detailsViewController.detailsViewModel.targetTvShow = tvDataToDisplay.id ?? 0
                detailsViewController.detailsViewModel.movieOrTvShow = 1
            }
        }
    }
}

extension TrendingViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchPerformed = true
        TrendingCollectionViewCell.shared.searchPerformed = true
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        trendingViewModel.loadMovies(searchPerformed: self.searchPerformed,
                                     query: self.trendingSearchBar.text ?? "")
        trendingViewModel.loadTvShows(searchPerformed: self.searchPerformed,
                                      query: self.trendingSearchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchPerformed = false
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        TrendingCollectionViewCell.shared.searchPerformed = false
        trendingViewModel.loadMovies(searchPerformed: self.searchPerformed,
                                     query: self.trendingSearchBar.text ?? "")
        trendingViewModel.loadTvShows(searchPerformed: self.searchPerformed,
                                      query: self.trendingSearchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            
            self.searchPerformed = true
            TrendingCollectionViewCell.shared.searchPerformed = true
            self.trendingViewModel.loadMovies(searchPerformed: self.searchPerformed,
                                              query: self.trendingSearchBar.text ?? "")
            self.trendingViewModel.loadTvShows(searchPerformed: self.searchPerformed,
                                               query: self.trendingSearchBar.text ?? "")
        }
    }
}
