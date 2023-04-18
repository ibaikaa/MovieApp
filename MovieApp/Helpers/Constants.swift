//
//  Constants.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import Foundation

/// Структура Constants содержит в себе постоянные значения, которые используются в приложении.
struct Constants {
    /// Shared Instance
    static let sharedInstance = Constants()
    
    /// Основная URL для API запросов
    public let baseURL: String = "https://imdb-api.com"
    
    /// API ключ для доступа к IMDb API.
    private let API_KEY = "k_x23v8os7"
    
    /// Метод возвращает API ключ для доступа к IMDb API.
    public func getApiKey() -> String { API_KEY }
    
    // MARK: - for CoreData
    enum EntityAttributeKeys: String {
        case id = "id"
        case title = "title"
        case fullTitle = "fullTitle"
        case year = "year"
        case rank = "rank"
        case rating = "rating"
        case ratingCount = "ratingCount"
        case crew = "crew"
        case posterPath = "posterPath"
    }
    
}

