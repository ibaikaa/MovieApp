//
//  Int+PlaceEmojiHandling.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import Foundation

/// Метод, который возвращает смайлик в зависимости от значения параметра place. Используется для первых трех по рангу фильмов.

extension Int {
    func getRankEmoji() -> String {
        switch self {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return ""
        }
    }
}
