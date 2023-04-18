//
//  FavoriteMoviesViewModel.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import Foundation
import RxSwift

final class FavoriteMoviesViewModel {
    // MARK: - Приватные свойства
    private let coreDataManager = CoreDataManager.shared
    private var favoriteMoviesSubject = PublishSubject<[FavoriteMovie]>() {
        didSet {
            print("новое значение.")
        }
    }
    private let errorSubject = PublishSubject<Error>()
    
    public var favoriteMoviesObservable: Observable<[FavoriteMovie]> {
        return favoriteMoviesSubject.asObservable()
    }
    
    // MARK: - Методы
    
    /**
     Метод получения списка избранных фильмов.
     */
    public func fetchFavoriteMovies() -> Observable<[FavoriteMovie]> {
        return Observable.create { observer in
            self.coreDataManager.fetchFavoriteMovies { result in
                switch result {
                case .success(let movies):
                    observer.onNext(movies)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    public func getM() {
        fetchFavoriteMovies()
            .subscribe(onNext: { movies in
                print("КОЛВО-\(movies.count)")
                self.favoriteMoviesSubject.onNext(movies)
            }, onError: { error in
                self.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    public func fetxh() {
        coreDataManager.fetchRX().subscribe { movies in
            print("КОЛВО-\(movies.count)")
            self.favoriteMoviesSubject.onNext(movies)
        } onError: { error in
            self.errorSubject.onNext(error)
        }
        .disposed(by: disposeBag)
    }
    
}
