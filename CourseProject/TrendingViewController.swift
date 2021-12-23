//
//  ViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit
import Alamofire

class TrendingViewController: UIViewController {
    
    @IBOutlet weak var TrendingCollectionView: UICollectionView!
    @IBOutlet weak var trendingSegmentedControl: UISegmentedControl!
    
    private let refreshControl = UIRefreshControl()
    var savedMoviesArray : [ResultsToSave] = []
    var savedSeriesArray : [ResultsToSave] = []
    let requestUrl = "https://api.themoviedb.org/3/trending/all/day?api_key=0b7fec5fcf33f299afcdde35a5fa4843"
    var responceDataArray: [Results] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trendingSegmentedControl.selectedSegmentIndex = 0
        self.trendingSegmentedControlSetUp(forIndex: trendingSegmentedControl.selectedSegmentIndex)
        
        self.TrendingCollectionView.layer.backgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0, yellow: 0, black: 0, alpha: 0)
        self.TrendingCollectionView.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TrendingCollectionViewCell")
        
        self.title = "Trending for today"
        
        performRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.layer.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func performRequest() {
        
        AF.request(requestUrl, method: .get).responseJSON { responceData1 in
            
            do {
                
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(ResultsModel.self, from: responceData1.data!)
                for _ in responseModel.results! {
                    self.responceDataArray.append(responseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                
                DataManager().clearRealm()
                indexForAppend = 0
                
                for _ in self.responceDataArray {
                    DataManager().saveItems(genreIds: self.responceDataArray[indexForAppend].genreIds ?? [], originalLanguage: self.responceDataArray[indexForAppend].originalLanguage ?? "",
                                            originalTitle: self.responceDataArray[indexForAppend].originalTitle ?? self.responceDataArray[indexForAppend].originalName ?? "",
                                            originalName: self.responceDataArray[indexForAppend].originalName ?? "",
                                            posterPath: self.responceDataArray[indexForAppend].posterPath ?? "",
                                            video: self.responceDataArray[indexForAppend].video ?? false,
                                            voteAverage: self.responceDataArray[indexForAppend].voteAverage ?? 0.0,
                                            voteCount: self.responceDataArray[indexForAppend].voteCount ?? 0,
                                            overview: self.responceDataArray[indexForAppend].overview ?? "",
                                            releaseDate: self.responceDataArray[indexForAppend].releaseDate ?? self.responceDataArray[indexForAppend].firstAirDate ?? "",
                                            firstAirDate: self.responceDataArray[indexForAppend].firstAirDate ?? "",
                                            title: self.responceDataArray[indexForAppend].title ?? self.responceDataArray[indexForAppend].name ?? "",
                                            name: self.responceDataArray[indexForAppend].name ?? "",
                                            id: self.responceDataArray[indexForAppend].id ?? 0,
                                            adult: self.responceDataArray[indexForAppend].adult ?? true,
                                            backdropPath: self.responceDataArray[indexForAppend].backdropPath ?? "",
                                            popularity: self.responceDataArray[indexForAppend].popularity ?? 0.0,
                                            mediaType: self.responceDataArray[indexForAppend].mediaType ?? "")
                    indexForAppend += 1
                }
                self.trendingSegmentedControlSetUp(forIndex: self.trendingSegmentedControl.selectedSegmentIndex)
                indexForAppend = 0
            } catch {
                print(error)
                self.trendingSegmentedControlSetUp(forIndex: self.trendingSegmentedControl.selectedSegmentIndex)
            }
        }
    }
    
    func trendingSegmentedControlSetUp(forIndex: Int) {
        if forIndex == 0 {
            self.savedMoviesArray = DataManager().getMovies()
            self.TrendingCollectionView.reloadData()
        } else {
            self.savedSeriesArray = DataManager().getSeries()
            self.TrendingCollectionView.reloadData()
        }
    }
    
    @IBAction func trendingSegmentedControlSwitched(_ sender: Any) {
        trendingSegmentedControlSetUp(forIndex: trendingSegmentedControl.selectedSegmentIndex)
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
        
        var dataToDisplay = ResultsToSave()
        
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            dataToDisplay = savedMoviesArray[indexPath.row]
        } else if trendingSegmentedControl.selectedSegmentIndex == 1 {
            dataToDisplay = savedSeriesArray[indexPath.row]
        }
        
        trendingCell.configureCell(dataToDisplay: dataToDisplay)
        
        return trendingCell
    }
    
    
}

extension TrendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var dataToDisplay1 = ResultsToSave()
        if trendingSegmentedControl.selectedSegmentIndex == 0 {
            dataToDisplay1 = savedMoviesArray[indexPath.row]
        } else if trendingSegmentedControl.selectedSegmentIndex == 1 {
            dataToDisplay1 = savedSeriesArray[indexPath.row]
        }
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let detailsViewController = main.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            navigationController?.pushViewController(detailsViewController, animated: true)
            detailsViewController.backgroundImageViewURL = dataToDisplay1.posterPath
            detailsViewController.detailsTitle = dataToDisplay1.title
            detailsViewController.detailsPosterURL = dataToDisplay1.posterPath
            detailsViewController.detailsDescription = dataToDisplay1.overview
            detailsViewController.detailsAverageVote = dataToDisplay1.voteAverage
            detailsViewController.detailsVoteCount = dataToDisplay1.voteCount
            detailsViewController.detailsGenres = dataToDisplay1.genreIds
            detailsViewController.detailsOriginalLanguage = dataToDisplay1.originalLanguage
        }
    }
}
