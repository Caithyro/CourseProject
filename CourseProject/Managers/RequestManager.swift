//
//  RequestManager.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 24.12.2021.
//

import Foundation
import Alamofire
import RealmSwift

class RequestManager {
    
    static let shared = RequestManager()
    weak var trendingViewControllerInstance = TrendingViewController()
    weak var detailsViewControllerInstance = DetailsViewController()
    
    var moviesResponceData: [MoviesResults] = []
    var tvShowsResponceData: [TvResults] = []
    var movieCastResponceData: [MovieCastResults] = []
    var tvCastResponceData: [TvCastResults] = []
    var movieId = ""
    let movieRequestUrl = "https://api.themoviedb.org/3/trending/movie/day?api_key=0b7fec5fcf33f299afcdde35a5fa4843"
    let tvRequestUrl = "https://api.themoviedb.org/3/trending/tv/day?api_key=0b7fec5fcf33f299afcdde35a5fa4843"
    
    func requestMovies() {
        
        AF.request(movieRequestUrl, method: .get).responseJSON { [self]moviesResponceData1 in
            
            do {
                
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let moviesResponseModel = try jsonDecoder.decode(MoviesResultsModel.self, from: moviesResponceData1.data!)
                for _ in moviesResponseModel.results! {
                    self.moviesResponceData.append(moviesResponseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                
                indexForAppend = 0
                
                if DataManager.shared.moviesRealm.isEmpty == false {
                    DataManager.shared.clearMoviesRealm()
                }
                
                for _ in self.moviesResponceData {
                    DataManager.shared.saveMovies(id: self.moviesResponceData[indexForAppend].id ?? 0,
                                             releaseDate: self.moviesResponceData[indexForAppend].releaseDate ?? "",
                                             adult: self.moviesResponceData[indexForAppend].adult ?? false,
                                             backdropPath: self.moviesResponceData[indexForAppend].backdropPath ?? "",
                                             voteCount: self.moviesResponceData[indexForAppend].voteCount ?? 0,
                                             overview: self.moviesResponceData[indexForAppend].overview ?? "",
                                             originalLanguage: self.moviesResponceData[indexForAppend].originalLanguage ?? "",
                                             originalTitle: self.moviesResponceData[indexForAppend].originalTitle ?? "",
                                             posterPath: self.moviesResponceData[indexForAppend].posterPath ?? "",
                                             title: self.moviesResponceData[indexForAppend].title ?? "",
                                             video: self.moviesResponceData[indexForAppend].video ?? false,
                                             voteAverage: self.moviesResponceData[indexForAppend].voteAverage ?? 0.0,
                                             popularity: self.moviesResponceData[indexForAppend].popularity ?? 0.0,
                                             mediaType: self.moviesResponceData[indexForAppend].mediaType ?? "")
                    indexForAppend += 1
                }
                indexForAppend = 0
                trendingViewControllerInstance?.savedMoviesArray = DataManager.shared.getMovies()
                trendingViewControllerInstance?.TrendingCollectionView.reloadData()
            } catch {
                print(error)
                trendingViewControllerInstance?.savedMoviesArray = DataManager.shared.getMovies()
                trendingViewControllerInstance?.TrendingCollectionView.reloadData()
            }
        }
    }
    
    func requestTvShows() {
        
        AF.request(tvRequestUrl, method: .get).responseJSON { seriesResponceData1 in
            
            do {
                
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let seriesResponseModel = try jsonDecoder.decode(TvResultsModel.self, from: seriesResponceData1.data!)
                for _ in seriesResponseModel.results! {
                    self.tvShowsResponceData.append(seriesResponseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                            
                indexForAppend = 0
                
                for _ in self.tvShowsResponceData {
                    DataManager.shared.saveTvShows(originalLanguage: self.tvShowsResponceData[indexForAppend].originalLanguage ?? "",
                                              posterPath: self.tvShowsResponceData[indexForAppend].posterPath ?? "",
                                              voteCount: self.tvShowsResponceData[indexForAppend].voteCount ?? 0,
                                              voteAverage: self.tvShowsResponceData[indexForAppend].voteAverage ?? 0.0,
                                              overview: self.tvShowsResponceData[indexForAppend].overview ?? "",
                                              id: self.tvShowsResponceData[indexForAppend].id ?? 0,
                                              originalName: self.tvShowsResponceData[indexForAppend].originalName ?? "",
                                              firstAirDate: self.tvShowsResponceData[indexForAppend].firstAirDate ?? "",
                                              name: self.tvShowsResponceData[indexForAppend].name ?? "",
                                              backdropPath: self.tvShowsResponceData[indexForAppend].backdropPath ?? "",
                                              popularity: self.tvShowsResponceData[indexForAppend].popularity ?? 0.0,
                                              mediaType: self.tvShowsResponceData[indexForAppend].mediaType ?? "")
                    indexForAppend += 1
                }
                indexForAppend = 0
            } catch {
                print(error)
            }
        }
    }
    
    func requestMovieCast(targetMovieId: Int) {

        AF.request("https://api.themoviedb.org/3/movie/\(targetMovieId)/credits?api_key=0b7fec5fcf33f299afcdde35a5fa4843&language=en-US", method: .get).responseJSON { [self] movieCastResponceData1 in

            do {

                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let movieCastResponseModel = try jsonDecoder.decode(MovieCastAndCrewResultsModel.self, from: movieCastResponceData1.data!)
                for _ in movieCastResponseModel.movieCast! {
                    self.movieCastResponceData.append(movieCastResponseModel.movieCast![indexForAppend])
                    indexForAppend += 1
                }

                indexForAppend = 0

                for _ in self.movieCastResponceData {
                    DataManager.shared.saveMovieCast(adult: self.movieCastResponceData[indexForAppend].adult ?? false,
                                           gender: self.movieCastResponceData[indexForAppend].gender ?? 0,
                                           id: self.movieCastResponceData[indexForAppend].id ?? 0,
                                           knownForDepartment: self.movieCastResponceData[indexForAppend].knownForDepartment ?? "",
                                           name: self.movieCastResponceData[indexForAppend].name ?? "",
                                           originalName: self.movieCastResponceData[indexForAppend].originalName ?? "",
                                           popularity: self.movieCastResponceData[indexForAppend].popularity ?? 0.0,
                                           profilePath: self.movieCastResponceData[indexForAppend].profilePath ?? "",
                                           castId: self.movieCastResponceData[indexForAppend].castId ?? 0,
                                           character: self.movieCastResponceData[indexForAppend].character ?? "",
                                           creditId: self.movieCastResponceData[indexForAppend].creditId ?? "",
                                           order: self.movieCastResponceData[indexForAppend].order ?? 0)
                    indexForAppend += 1
                }
                indexForAppend = 0
                detailsViewControllerInstance?.savedMovieCast = DataManager.shared.getMovieCast()
                detailsViewControllerInstance?.detailsCastCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func requestTvCast(targetShowId: Int) {

        AF.request("https://api.themoviedb.org/3/tv/\(targetShowId)/credits?api_key=0b7fec5fcf33f299afcdde35a5fa4843&language=en-US", method: .get).responseJSON { [self] tvCastResponceData1 in

            do {

                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let tvCastResponseModel = try jsonDecoder.decode(TvCastAndCrewResultsModel.self, from: tvCastResponceData1.data!)
                for _ in tvCastResponseModel.tvCast! {
                    self.tvCastResponceData.append(tvCastResponseModel.tvCast![indexForAppend])
                    indexForAppend += 1
                }

                indexForAppend = 0

                for _ in self.tvCastResponceData {
                    DataManager.shared.saveTvCast(adult: self.tvCastResponceData[indexForAppend].adult ?? false,
                                                  gender: self.tvCastResponceData[indexForAppend].gender ?? 0,
                                                  id: self.tvCastResponceData[indexForAppend].id ?? 0,
                                                  knownForDepartment: self.tvCastResponceData[indexForAppend].knownForDepartment ?? "",
                                                  name: self.tvCastResponceData[indexForAppend].name ?? "",
                                                  originalName: self.tvCastResponceData[indexForAppend].originalName ?? "",
                                                  popularity: self.tvCastResponceData[indexForAppend].popularity ?? 0.0,
                                                  profilePath: self.tvCastResponceData[indexForAppend].profilePath ?? "",
                                                  character: self.tvCastResponceData[indexForAppend].character ?? "",
                                                  creditId: self.tvCastResponceData[indexForAppend].creditId ?? "" ,
                                                  order: self.tvCastResponceData[indexForAppend].order ?? 0)
                    indexForAppend += 1
                }
                indexForAppend = 0
                detailsViewControllerInstance?.savedTvCast = DataManager.shared.getTvCast()
                detailsViewControllerInstance?.detailsCastCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
}
