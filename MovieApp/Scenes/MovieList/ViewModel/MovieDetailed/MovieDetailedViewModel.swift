//
//  MovieDetailedViewModel.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import UIKit
import Kingfisher
import RxSwift

final class MovieDetailedViewModel {
    // MARK: - Приватные свойства
    private let coreDataManager = CoreDataManager.shared
    private let networkLayer = NetworkLayer.shared
    private let disposeBag = DisposeBag()
    private var movie: Item
    
    // MARK: - Публичные свойства
    public var showAlert: ((String) -> Void)?
    
    // MARK: - Инициализатор
    init(movie: Item) {
        self.movie = movie
        fetchFavoriteMovies()
    }
    
    // MARK: - Публичные методы
    
    // MARK: - Методы для получения данных в UI-элементы.
    
    public func getRank() -> String {
        guard let rank = movie.rank, let rankValue = Int(rank) else {
            return "No Data"
        }
        
        if (1...3).contains(rankValue) {
            return "\(rank) \(rankValue.getRankEmoji())"
        } else {
            return rank
        }
    }
    
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
    
    public func getTrailerURLString(
        completion: @escaping (String) -> Void
    ) {
        networkLayer.getMovieWithTrailer(id: movie.id)
            .map { $0.videoURL }
            .subscribe(onNext: { videoURL in
                print(videoURL) // https://www.youtube.com/watch?v=K_tLp7T6U1c
                completion(videoURL)
            }, onError: { [weak self] error in
                self?.showAlert?(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Работы с данными CoreDataManager
    
    /// Метод для стягивания всех избранных фильмов. Нужен для того, чтоб получить текущий фильм в виде класса `FavoriteMovie`
    private func fetchFavoriteMovies() {
        coreDataManager.fetchFavoriteMovies { [unowned self] result in
            switch result {
            case .success(let movies):
                movieAsFavorite = movies.first(where: { $0.id == movie.id })
            case .failure(let error):
                self.showAlert?(error.localizedDescription)
            }
        }
    }
    
    /// Свойство, используемое для определения, фильм в избранном или нет.
    public var isFavoriteMovie: Bool = false
    
    /// Свойство, необходимое для работы с CoreData (удаление/добавление)
    private var movieAsFavorite: FavoriteMovie? {
        didSet {
            // В избранных ли фильм определяется так: существует ли фильм в избранных.
            isFavoriteMovie = movieAsFavorite != nil
        }
    }
    
    /// Метод для добавления фильма в CoreData.
    private func addFavoriteMovie() {
        coreDataManager.saveFavoriteMovie(
            id: movie.id,
            title: movie.title ?? "No Data",
            fullTitle: movie.fullTitle ?? "No Data",
            year: movie.year ?? "No Data",
            rank: movie.rank ?? "No Data",
            rating: movie.rating ?? "No Data",
            ratingCount: movie.ratingCount ?? "No Data",
            crew: movie.crew ?? "No Data",
            posterPath: movie.posterPath ?? "No Data"
        ) { [unowned self] error in
            if let error = error {
                self.showAlert?(error.localizedDescription)
            }
        }
    }
    
    /// Метод для удаления фильма из CoreData.
    private func removeMovieFromFavorites() {
        guard let movieToDelete = movieAsFavorite else { return }
        coreDataManager.removeMovieFromFavorites(movieToDelete){ [unowned self] error in
            if let error = error {
                self.showAlert?(error.localizedDescription)
            }
        }
    }
    
    /// Метод, вызывающийся при нажатии на кнопку.
    public func didTapAddToFavoritesButton() {
        isFavoriteMovie ? removeMovieFromFavorites() : addFavoriteMovie()
    }
    
}