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
    private let API_KEY = "k_de623q34"
    
    /// Метод возвращает API ключ для доступа к IMDb API.
    public func getApiKey() -> String { API_KEY }
}
