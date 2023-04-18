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
