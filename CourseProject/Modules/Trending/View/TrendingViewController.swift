//
//  ViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit

class TrendingViewController: UIViewController {
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var trendingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var trendingSearchBar: UISearchBar!
    
    var trendingViewModel = TrendingViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doStartupSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.layer.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func trendingSegmentedControlSwitched(_ sender: Any) {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            trendingViewModel.loadMovies(searchPerformed: trendingViewModel.searchPerformed,
                                         query: self.trendingSearchBar.text ?? "", completion: {
                self.trendingCollectionView.reloadData()
            })
            trendingViewModel.movieOrTvShow = 0
        } else {
            trendingViewModel.loadTvShows(searchPerformed: trendingViewModel.searchPerformed,
                                          query: self.trendingSearchBar.text ?? "", completion: {
                self.trendingCollectionView.reloadData()
            })
            trendingViewModel.movieOrTvShow = 1
        }
    }
    
    // MARK: - Private
    
    private func doStartupSetup() {
        
        self.trendingCollectionView.layer.backgroundColor = transparentBackgroundColor
        self.trendingCollectionView.register(UINib(nibName: trendingCellName,
                                                   bundle: nil), forCellWithReuseIdentifier: trendingCellName)
        trendingViewModel.loadMovies(searchPerformed: trendingViewModel.searchPerformed,
                                     query: self.trendingSearchBar.text ?? "", completion: {
            self.trendingCollectionView.reloadData()
        })
        trendingViewModel.loadTvShows(searchPerformed: trendingViewModel.searchPerformed,
                                      query: self.trendingSearchBar.text ?? "", completion: {
            self.trendingCollectionView.reloadData()
        })
        trendingSegmentedControl.selectedSegmentIndex = 0
        trendingViewModel.movieOrTvShow = 0
        trendingSearchBar.showsCancelButton = false
        self.title = trendingTitleString
        
    }
}

// MARK: - Extensions

extension TrendingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            return trendingViewModel.moviesResponceData.count
        } else {
            return trendingViewModel.tvShowsResponceData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            
            guard let trendingCell = trendingCollectionView.dequeueReusableCell(withReuseIdentifier: trendingCellName,
                                                                                for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
            
            var moviesDataToDisplay = trendingViewModel.moviesResponceData
            let eachSearchedMovie = moviesDataToDisplay[indexPath.row]
            trendingCell.configureMoviesCell(dataToDisplay: eachSearchedMovie)
            for _ in moviesDataToDisplay {
                moviesDataToDisplay.remove(at: 0)
            }
            return trendingCell
        } else {
            guard let trendingCell = trendingCollectionView.dequeueReusableCell(withReuseIdentifier: trendingCellName,
                                                                                for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
            
            var tvDataToDisplay = trendingViewModel.tvShowsResponceData
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
            let movieDataToDisplay = trendingViewModel.moviesResponceData[indexPath.row]
            let main = UIStoryboard(name: storyboardName, bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier:
                                                                            detailsViewControllerName)
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
            let tvDataToDisplay = trendingViewModel.tvShowsResponceData[indexPath.row]
            let main = UIStoryboard(name: storyboardName, bundle: nil)
            if let detailsViewController = main.instantiateViewController(withIdentifier:
                                                                            detailsViewControllerName)
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
        
        trendingViewModel.searchPerformed = true
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        trendingViewModel.loadMovies(searchPerformed: trendingViewModel.searchPerformed,
                                     query: self.trendingSearchBar.text ?? "", completion: {
            self.trendingCollectionView.reloadData()
        })
        trendingViewModel.loadTvShows(searchPerformed: trendingViewModel.searchPerformed,
                                      query: self.trendingSearchBar.text ?? "", completion: {
            self.trendingCollectionView.reloadData()
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        trendingViewModel.searchPerformed = false
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        trendingViewModel.searchPerformed = false
        trendingViewModel.loadMovies(searchPerformed: trendingViewModel.searchPerformed,
                                     query: self.trendingSearchBar.text ?? "", completion: {
            self.trendingCollectionView.reloadData()
        })
        trendingViewModel.loadTvShows(searchPerformed: trendingViewModel.searchPerformed,
                                      query: self.trendingSearchBar.text ?? "", completion: {
            self.trendingCollectionView.reloadData()
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            
            self.trendingViewModel.searchPerformed = true
            self.trendingViewModel.loadMovies(searchPerformed: self.trendingViewModel.searchPerformed,
                                              query: self.trendingSearchBar.text ?? "", completion: {
                self.trendingCollectionView.reloadData()
            })
            self.trendingViewModel.loadTvShows(searchPerformed: self.trendingViewModel.searchPerformed,
                                               query: self.trendingSearchBar.text ?? "", completion: {
                self.trendingCollectionView.reloadData()
            })
        }
    }
}
