//
//  Movie.swift
//  MovieAPI
//
//  Created by Mitya Kim on 2/2/22.
//

import Foundation

struct TopLevelObject: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let title: String
    let vote_average: Double
    let overview: String
    let poster_path: String
}



