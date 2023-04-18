//
//  MovieDetailedViewModel.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import UIKit
import Kingfisher

final class MovieDetailedViewModel {
    public var movie: Item
    
    init(movie: Item) {
        self.movie = movie
    }
    
    public func getRank() -> String { movie.rank ?? "No Rank Data" }
    
    public func setPosterImage(for imageView: UIImageView) {
        imageView.kf.setImage(
            with: URL(string:movie.posterPath ?? ""),
            placeholder: UIImage(systemName: "popcorn.fill")
        )
    }
    
    public func getFullTitle() -> String { movie.fullTitle ?? "No Data" }
    
    public func getRatingValue() -> Double {
        guard let rating = movie.rating, let ratingValue = Double(rating) else {
            return 0
        }
        
        return ratingValue / 2
    }
    
    public func getRating() -> String { movie.rating ?? "No Data" }
    
    public func getRatingCount() -> String {
        guard let ratingCount = movie.ratingCount, let ratingCountValue = Int(ratingCount) else {
            return "No Data"
        }
        
        return "(\(ratingCountValue.withCommas()))"
    }
    
    public func getCrew() -> String { movie.crew ?? "No Data" }
    
}
