//
//  MovieDTO.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import Foundation

/// Структура `MovieGroup`, содержащая в себе массив из фильмов (название endpoint'а для фильма – `item`)
struct MovieGroup: Decodable {
    let items: [Item]?
}

/// Структура `Item`, содержащая в себе всю возможную информацию о фильме.
struct Item: Decodable {
    let id: String
    let rank: String?
    let title: String?
    let fullTitle: String?
    let year: String?
    let posterPath: String?
    let crew: String?
    let rating: String?
    let ratingCount: String?
    
    /// `CodingKeys` для лучшей читабельности кода и названий свойств.
    /// Использовано для того, чтоб поменять `imDbRating` и `ImDbRatingCount` на `rating` и `ratingCount` соотвественно. Также для изменения `image` на `posterPath`.
    enum CodingKeys: String, CodingKey {
        case id, rank, title, fullTitle, year
        case posterPath = "image"
        case crew
        case rating = "imDbRating"
        case ratingCount = "imDbRatingCount"
    }
    
}
