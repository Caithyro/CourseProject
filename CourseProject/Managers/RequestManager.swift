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
    var movieTrailersResponceData: [MovieTrailersRelults] = []
    var tvTrailersResponceData: [TvTrailersRelults] = []
    var movieSearchResponceData: [MovieSearchResults] = []
    var tvSearchResponceData: [TvSearchResults] = []
    var movieId = ""
    let movieRequestUrl = "https://api.themoviedb.org/3/trending/movie/day?api_key=0b7fec5fcf33f299afcdde35a5fa4843"
    let tvRequestUrl = "https://api.themoviedb.org/3/trending/tv/day?api_key=0b7fec5fcf33f299afcdde35a5fa4843"
    
    func requestMovies() {
        
        AF.request(movieRequestUrl).responseJSON { [self]moviesResponceData1 in
            
            do {
                
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let moviesResponseModel = try jsonDecoder.decode(MoviesResultsModel.self, from: moviesResponceData1.data!)
                for _ in moviesResponseModel.results! {
                    self.moviesResponceData.append(moviesResponseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                
                indexForAppend = 0
                
                DataManager.shared.clearTrendingMovies()
                
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
                trendingViewControllerInstance?.trendingCollectionView.reloadData()
            } catch {
                print(error)
                trendingViewControllerInstance?.savedMoviesArray = DataManager.shared.getMovies()
                trendingViewControllerInstance?.trendingCollectionView.reloadData()
            }
        }
    }
    
    func requestTvShows() {
        
        AF.request(tvRequestUrl).responseJSON { tvResponceData1 in
            
            do {
                
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let tvResponseModel = try jsonDecoder.decode(TvResultsModel.self, from: tvResponceData1.data!)
                for _ in tvResponseModel.results! {
                    self.tvShowsResponceData.append(tvResponseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                
                indexForAppend = 0
                
                DataManager.shared.clearTrendingSeries()
                
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
        
        AF.request("https://api.themoviedb.org/3/movie/\(targetMovieId)/credits?api_key=0b7fec5fcf33f299afcdde35a5fa4843&language=en-US").responseJSON { [self] movieCastResponceData1 in
            
            do {
                
                movieCastResponceData.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let movieCastResponseModel = try jsonDecoder.decode(MovieCastAndCrewResultsModel.self, from: movieCastResponceData1.data!)
                for _ in movieCastResponseModel.movieCast! {
                    self.movieCastResponceData.append(movieCastResponseModel.movieCast![indexForAppend])
                    indexForAppend += 1
                }
                
                indexForAppend = 0
                
                DataManager.shared.clearMovieCast()
                
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
        
        AF.request("https://api.themoviedb.org/3/tv/\(targetShowId)/credits?api_key=0b7fec5fcf33f299afcdde35a5fa4843&language=en-US").responseJSON { [self] tvCastResponceData1 in
            
            do {
                
                tvCastResponceData.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let tvCastResponseModel = try jsonDecoder.decode(TvCastAndCrewResultsModel.self, from: tvCastResponceData1.data!)
                for _ in tvCastResponseModel.tvCast! {
                    self.tvCastResponceData.append(tvCastResponseModel.tvCast![indexForAppend])
                    indexForAppend += 1
                }
                
                indexForAppend = 0
                
                DataManager.shared.clearTvCast()
                
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
    
    func requestMovieTrailers(targetMovie: Int) {
        
        AF.request("https://api.themoviedb.org/3/movie/\(targetMovie)/videos?api_key=0b7fec5fcf33f299afcdde35a5fa4843&language=en-US").responseJSON { [self]movieTrailersResponceData1 in
            
            do {
                
                movieTrailersResponceData.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let movieTrailersResponseModel = try jsonDecoder.decode(MovieTrailersRelultsModel.self, from: movieTrailersResponceData1.data!)
                for _ in movieTrailersResponseModel.results! {
                    self.movieTrailersResponceData.append(movieTrailersResponseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                
                indexForAppend = 0
                
                DataManager.shared.clearMovieTrailers()
                
                for _ in self.movieTrailersResponceData {
                    DataManager.shared.saveMovieTrailers(iso6391: self.movieTrailersResponceData[indexForAppend].iso6391 ?? "",
                                                         iso31661: self.movieTrailersResponceData[indexForAppend].iso31661 ?? "",
                                                         name: self.movieTrailersResponceData[indexForAppend].name ?? "",
                                                         key: self.movieTrailersResponceData[indexForAppend].key ?? "",
                                                         site: self.movieTrailersResponceData[indexForAppend].site ?? "",
                                                         size: self.movieTrailersResponceData[indexForAppend].size ?? 0,
                                                         type: self.movieTrailersResponceData[indexForAppend].type ?? "",
                                                         official: self.movieTrailersResponceData[indexForAppend].official ?? false,
                                                         publishedAt: self.movieTrailersResponceData[indexForAppend].publishedAt ?? "",
                                                         id: self.movieTrailersResponceData[indexForAppend].id ?? "")
                    indexForAppend += 1
                }
                indexForAppend = 0
                detailsViewControllerInstance?.savedMovieTrailers = DataManager.shared.getMovieTrailers()
                detailsViewControllerInstance?.detailsPlayerView.load(withVideoId: detailsViewControllerInstance?.savedMovieTrailers.first?.key ?? "")
            } catch {
                print(error)
            }
        }
    }
    
    func requestTvTrailers(targetShow: Int) {
        
        AF.request("https://api.themoviedb.org/3/tv/\(targetShow)/videos?api_key=0b7fec5fcf33f299afcdde35a5fa4843&language=en-US").responseJSON { [self]tvTrailersResponceData1 in
            
            do {
                
                tvTrailersResponceData.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let tvTrailersResponseModel = try jsonDecoder.decode(TvTrailersRelultsModel.self, from: tvTrailersResponceData1.data!)
                for _ in tvTrailersResponseModel.results! {
                    self.tvTrailersResponceData.append(tvTrailersResponseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                
                indexForAppend = 0
                
                DataManager.shared.clearTvTrailers()
                
                for _ in self.tvTrailersResponceData {
                    DataManager.shared.saveTvTrailers(iso6391: self.tvTrailersResponceData[indexForAppend].iso6391 ?? "",
                                                      iso31661: self.tvTrailersResponceData[indexForAppend].iso31661 ?? "",
                                                      name: self.tvTrailersResponceData[indexForAppend].name ?? "",
                                                      key: self.tvTrailersResponceData[indexForAppend].key ?? "",
                                                      site: self.tvTrailersResponceData[indexForAppend].site ?? "",
                                                      size: self.tvTrailersResponceData[indexForAppend].size ?? 0,
                                                      type: self.tvTrailersResponceData[indexForAppend].type ?? "",
                                                      official: self.tvTrailersResponceData[indexForAppend].official ?? false,
                                                      publishedAt: self.tvTrailersResponceData[indexForAppend].publishedAt ?? "",
                                                      id: self.tvTrailersResponceData[indexForAppend].id ?? "")
                    indexForAppend += 1
                }
                indexForAppend = 0
                detailsViewControllerInstance?.savedTvTrailers = DataManager.shared.getTvTrailers()
                detailsViewControllerInstance?.detailsPlayerView.load(withVideoId: detailsViewControllerInstance?.savedTvTrailers.first?.key ?? "")
            } catch {
                print(error)
            }
        }
    }
    
    func movieSearchRequest(query: String) {
        
        let emptyData = Data.init()
        let rightQuery = query.replacingOccurrences(of: " ", with: "%20")
        
        AF.request("https://api.themoviedb.org/3/search/movie?api_key=0b7fec5fcf33f299afcdde35a5fa4843&language=en-US&query=\(rightQuery)&page=1&include_adult=false").responseJSON { [self]movieSearchResponceData1 in
            
            do {
                self.movieSearchResponceData.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let movieSearchResponseModel = try jsonDecoder.decode(MovieSearchResultsModel.self, from: movieSearchResponceData1.data ?? emptyData)
                for _ in movieSearchResponseModel.results ?? [] {
                    self.movieSearchResponceData.append(movieSearchResponseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                indexForAppend = 0
            } catch {
                print(error)
            }
            trendingViewControllerInstance?.trendingCollectionView.reloadData()
        }
    }
    
    func tvSearchRequest(query: String) {
        
        let emptyData = Data.init()
        let rightQuery = query.replacingOccurrences(of: " ", with: "%20")
        
        AF.request("https://api.themoviedb.org/3/search/tv?api_key=0b7fec5fcf33f299afcdde35a5fa4843&language=en-US&page=1&query=\(rightQuery)&include_adult=false").responseJSON { [self]tvSearchResponceData1 in
            
            do {
                self.tvSearchResponceData.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let tvSearchResponseModel = try jsonDecoder.decode(TvSearchResultsModel.self, from: tvSearchResponceData1.data ?? emptyData)
                for _ in tvSearchResponseModel.results ?? [] {
                    self.tvSearchResponceData.append(tvSearchResponseModel.results![indexForAppend])
                    indexForAppend += 1
                }
                indexForAppend = 0
            } catch {
                print(error)
            }
            trendingViewControllerInstance?.trendingCollectionView.reloadData()
        }
    }
}
