//
//  ApiType.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import Alamofire

/// Протокол для ApiType, обязывающий содержать в себе следующие свойства у всех сущностей, которые подписываются на этот протокол.
protocol ApiTypeProtocol {
    var method: HTTPMethod { get }
    var languagePath: String { get }
    var path: String { get }
    var url: URL? { get }
}

/// Перечисление всех возможных API запросов, используемых в приложении.
enum ApiType: ApiTypeProtocol {
    
    /// Запрос для получения списка из ТОП 250 фильмов от IMDb.
    case getMovies
    
    /// Запрос для получения фильма по ID с ссылкой на трейлер
    case youtubeTrailerByID(id: String)
    
    /// HTTP метод, используемый для API запроса.
    var method: HTTPMethod {
        switch self {
        case .getMovies:
            return .get
        case .youtubeTrailerByID:
            return .get
        }
    }
    
    /// Определение языка для API запроса, основанное на языке устройства пользователя.
    var languagePath: String {
        let deviceLanguage = Locale.preferredLanguages.first ?? "/en"
        return "/\(deviceLanguage)/"
    }
    
    /// API endpoint для запроса
    var path: String {
        switch self {
        case .getMovies:
            return "API/Top250Movies/\(Constants.sharedInstance.getApiKey())"
        case .youtubeTrailerByID(let id):
            return "API/YouTubeTrailer/\(Constants.sharedInstance.getApiKey())/\(id)"
        }
    }
    
    /// Полная URL-ссылка для API запроса.
    var url: URL? {
        let urlString = Constants.sharedInstance.baseURL + languagePath + path
        return URL(string: urlString)
    }
    
}
