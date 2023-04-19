//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import RxSwift

final class MovieListViewModel {
    // MARK: - Свойства
    private let networkLayer = NetworkLayer.shared
    
    public var isLoading = BehaviorSubject<Bool>(value: false)

    private let moviesSubject = PublishSubject<[Item]>()
    private let errorSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    public var moviesObservable: Observable<[Item]> {
        return moviesSubject.asObservable()
    }
    
    public var searchMovieName = "" {
        didSet {
            getMovies()
        }
    }
    
    public var filteredMoviesObservable: Observable<[Item]> {
        return moviesObservable.map { [weak self] movies in
            guard let `self` = self else { return [] }
            print("movie to find: \(searchMovieName). empty: \(searchMovieName.isEmpty)")
            if searchMovieName.isEmpty {
                return movies
            } else {
                return movies.filter { ($0.title ?? "").contains(self.searchMovieName) }
            }
        }
    }
    
    public var errorObservable: Observable<Error> {
        return errorSubject.asObservable()
    } 
    
    // MARK: - Методы
    
    /// Метод получения списка фильмов.
    public func getMovies() {
        isLoading.onNext(true)
        networkLayer.getMovieList()
            .subscribe(
                onNext: { [weak self] movieGroup in
                    if let movies = movieGroup.items {
                        self?.moviesSubject.onNext(movies)
                        self?.isLoading.onNext(false)
                    }
                },
                onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                    self?.isLoading.onNext(false)

                }
            )
            .disposed(by: disposeBag)
    }
    
}

