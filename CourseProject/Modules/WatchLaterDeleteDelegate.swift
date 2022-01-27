//
//  DeleteProtocol.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 24.01.2022.
//

import Foundation

protocol WatchLaterDeleteDelegate {
    
    func removeMovie(targetMovie: Int, indexForRemove: Int)
    func removeTvShow(targetTvShow: Int, indexForRemove: Int)
}
