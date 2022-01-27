//
//  Constants.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 24.01.2022.
//

import Foundation
import UIKit

let detailsCellName = String(describing: DetailsCollectionViewCell.self)
let detailsAverageRateString = "Average rate -"
let detailsInString = "in"
let detailsVotesString = "votes"
let detailsUnknownString = "Unknown"
let watchLaterTitleString = "Watch later"
let watchLaterCellName = String(describing: WatchLaterCollectionViewCell.self)
let trendingSaveSuccessString = "Saved to watch later"
let trendingSaveFailString = "Save failed"
let trendingTitleString = "Trending for today"
let trendingCellName = String(describing: TrendingCollectionViewCell.self)
let trendingAlertShowingDuration = 1.2
let storyboardName = "Main"
let averageRatingString = "Average rating:"
let totalVotesString = "Total votes:"
let releaseDateString = "Release date:"
let firstAirString = "First air:"
let originalLanguageString = "Original language:"
let deleteString = "Delete"
let imageUrlString = "https://www.themoviedb.org/t/p/original"
let detailsViewControllerName = String(describing: DetailsViewController.self)
let originalLanguages: [String: String] = ["en" : "English", "es" : "Spanish", "ru" : "Russian",
                                           "ko": "Korean", "it" : "Italian", "ja" : "Japanese",
                                           "fr" : "French", "ml" : "Malayalam", "pl" : "Polish", "id" : "Indonesian", "nil" : "Unknown"]

let transparentBackgroundColor = CGColor(genericCMYKCyan: 0, magenta: 0,
                                            yellow: 0, black: 0, alpha: 0)
