//
//  ApiError.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import Foundation

/// Перечисление некоторых ошибок, которые могут появиться при работе с API-запросами
enum ApiError: Error {
    case invalidURL // Если URL = nil
    
    case forbidden // Статус код 403
    case notFound  // Статус код 404
    case conflict  // Статус код 409
    case internalServerError // Статус код 500

}
