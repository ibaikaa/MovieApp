//
//  MovieYouTubeTrailerDTO.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import Foundation

struct MovieWithTrailer: Codable {
    let id, fullTitle: String
    let videoID: String
    let videoURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, fullTitle
        case videoID = "videoId"
        case videoURL = "videoUrl"
    }
}
