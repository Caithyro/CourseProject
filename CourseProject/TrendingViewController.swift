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
    var responceDataArray: [Results] = []
    var savedDataArray: [ResultsToSave] = []
    let requestUrl = "https://api.themoviedb.org/3/trending/all/day?api_key=0b7fec5fcf33f299afcdde35a5fa4843"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TrendingCollectionView.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TrendingCollectionViewCell")
        
        AF.request(requestUrl, method: .get).responseJSON { responceData1 in
            
            do {
                
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(ResultsModel.self, from: responceData1.data!)
                for eachItem in responseModel.results! {
                    self.responceDataArray.append(responseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                
                indexForAppend = 0
                
                for eachItem in self.responceDataArray {
                    DataManager().saveItems(originalLanguage: self.responceDataArray[indexForAppend].originalLanguage ?? "",
                                            originalTitle: self.responceDataArray[indexForAppend].originalTitle ?? "",
                                            posterPath: self.responceDataArray[indexForAppend].posterPath ?? "",
                                            video: self.responceDataArray[indexForAppend].video ?? false,
                                            voteAverage: self.responceDataArray[indexForAppend].voteAverage ?? 0.0,
                                            voteCount: self.responceDataArray[indexForAppend].voteCount ?? 0,
                                            overview: self.responceDataArray[indexForAppend].overview ?? "",
                                            releaseDate: self.responceDataArray[indexForAppend].releaseDate ?? "",
                                            title: self.responceDataArray[indexForAppend].title ?? "",
                                            id: self.responceDataArray[indexForAppend].id ?? 0,
                                            adult: self.responceDataArray[indexForAppend].adult ?? true,
                                            backdropPath: self.responceDataArray[indexForAppend].backdropPath ?? "",
                                            popularity: self.responceDataArray[indexForAppend].popularity ?? 0.0,
                                            mediaType: self.responceDataArray[indexForAppend].mediaType ?? "")
                    indexForAppend += 1
                }
                self.savedDataArray = DataManager().getItems()
                self.TrendingCollectionView.reloadData()
                indexForAppend = 0
            } catch {
                print(error)
            }
        }
    }
}

extension TrendingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return savedDataArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let trendingCell = TrendingCollectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
        
        let dataToDisplay = savedDataArray[indexPath.row]
        trendingCell.configureCell(dataToDisplay: dataToDisplay)
        
        return trendingCell
    }
    
    
}

extension TrendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hello, \(indexPath.item)")
    }
}
