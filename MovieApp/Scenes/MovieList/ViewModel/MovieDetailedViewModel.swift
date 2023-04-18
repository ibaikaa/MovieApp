//
//  MovieDetailedViewModel.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import Foundation

final class MovieDetailedViewModel {
    private var movie: Item
    
    init(movie: Item) {
        self.movie = movie
    }
    
    public func getTitle() -> String? { movie.title }
}
