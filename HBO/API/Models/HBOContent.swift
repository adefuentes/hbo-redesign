//
//  HBOContent.swift
//  HBO
//
//  Created by Angel Fuentes on 05/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

public struct HBOContent: Decodable {
    public let vote_count: Int?
    public let id: Int?
    public let video: Bool
    public let vote_average: Float?
    public let title: String?
    public let popularity: Float?
    public let poster_path: String?
    public let original_language: String?
    public let original_title: String?
    public let genre_ids: [Int]?
    public let backdrop_path: String?
    public let adult: Bool?
    public let overview: String?
    public let release_date: String?
}

public struct HBODataContainer<Results: Decodable>: Decodable {
    public let page: Int
    public let total_results: Int
    public let total_pages: Int
    public let results: Results
}
