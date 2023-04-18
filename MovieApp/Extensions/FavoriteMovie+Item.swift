//
//  FavoriteMovie+Item.swift
//  MovieApp
//
//  Created by ibaikaa on 19/4/23.
//

import Foundation

/// Расширение для конвертации объекта класса `FavoriteMovie` в `Item`. Это возможно, так как свойства у них абсолютно одинаковы.
extension FavoriteMovie {
    func toMovieItem() -> Item {
        return Item(
            id: id,
            rank: rank,
            title: title,
            fullTitle: fullTitle,
            year: year,
            posterPath: posterPath,
            crew: crew,
            rating: rating,
            ratingCount: rating
        )
    }
    
}
