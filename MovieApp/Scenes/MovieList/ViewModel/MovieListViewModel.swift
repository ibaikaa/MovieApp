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
    
    private let moviesSubject = PublishSubject<[Item]>()
    private let errorSubject = PublishSubject<Error>()
    
    var moviesObservable: Observable<[Item]> {
        return moviesSubject.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Методы
    
    /**
     Метод получения списка фильмов.
     */
    public func getMovies() {
        networkLayer.getMovieList()
            .subscribe(
                onNext: { movieGroup in
                    if let movies = movieGroup.items {
                        self.moviesSubject.onNext(movies)
                        print("Emmited movies: \(movies.count)")
                    }
                },
                onError: { error in
                    self.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
}

enum MovieListError: Error {
    case indexOutOfRange
}
