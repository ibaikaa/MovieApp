//
//  FavoriteMoviesViewModel.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import RxSwift

final class FavoriteMoviesViewModel {
    // MARK: -  Свойства
    private let coreDataManager = CoreDataManager.shared
    
    private var favoriteMoviesSubject = PublishSubject<[FavoriteMovie]>()
    private let errorSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    public var favoriteMoviesObservable: Observable<[FavoriteMovie]> {
        return favoriteMoviesSubject.asObservable()
    }
    
    public var searchMovieName = "" {
        didSet {
            fetchFavoriteMovies()
        }
    }
    
    public var filteredMoviesObservable: Observable<[FavoriteMovie]> {
        return favoriteMoviesObservable.map { [weak self] movies in
            guard let `self` = self else { return [] }
            if searchMovieName.isEmpty {
                return movies
            } else {
                return movies.filter { $0.title .contains(self.searchMovieName) }
            }
        }
    }
    
    public var errorObservable: Observable<Error> {
        return errorSubject.asObservable()
    }

    // MARK: - Методы
    
    /// Метод получения списка избранных фильмов.
    public func fetchFavoriteMovies() {
        coreDataManager.fetchFavoriteMovies()
            .subscribe { movies in
                self.favoriteMoviesSubject.onNext(movies)
            } onError: { error in
                self.errorSubject.onNext(error)
            } 
            .disposed(by: disposeBag)
    }
    
}
