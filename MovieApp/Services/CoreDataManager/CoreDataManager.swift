//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import CoreData
import UIKit
import RxSwift

final class CoreDataManager {
    // MARK: - Singleton
    static let shared = CoreDataManager()
    private init() { }
    
    // MARK: - Приватные свойства
    
    /// Получение `persistentContainer'а` из `AppDelegate`.
    private var persistentContainer: NSPersistentContainer = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve App Delegate")
        }
        
        let container = appDelegate.persistentContainer
        return container
    }()
    
    // MARK: - Публичные методы
    
    /// Метод сохранения данных в CoreData
    public func saveFavoriteMovie(
        id: String,
        title: String,
        fullTitle: String,
        year: String,
        rank: String,
        rating: String,
        ratingCount: String,
        crew: String,
        posterPath: String,
        completion: @escaping ( (Error?) -> Void)
    ) {
        let managedContext = persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: "FavoriteMovie",
            in: managedContext
        ) else {
            completion(CoreDataError.entityNotFound)
            return
        }
        
        let favoriteMovie = FavoriteMovie(entity: entity, insertInto: managedContext)
        
        favoriteMovie.setValue(
            id,
            forKey: Constants.EntityAttributeKeys.id.rawValue
        )
        
        favoriteMovie.setValue(
            title,
            forKey: Constants.EntityAttributeKeys.title.rawValue
        )
        
        favoriteMovie.setValue(
            fullTitle,
            forKey: Constants.EntityAttributeKeys.fullTitle.rawValue
        )
        
        favoriteMovie.setValue(
            year,
            forKey: Constants.EntityAttributeKeys.year.rawValue
        )
        
        favoriteMovie.setValue(
            rank,
            forKey: Constants.EntityAttributeKeys.rank.rawValue
        )
        
        favoriteMovie.setValue(
            rating,
            forKey: Constants.EntityAttributeKeys.rating.rawValue
        )
        
        favoriteMovie.setValue(
            ratingCount,
            forKey: Constants.EntityAttributeKeys.ratingCount.rawValue
        )
        
        favoriteMovie.setValue(
            crew,
            forKey: Constants.EntityAttributeKeys.crew.rawValue
        )
        
        favoriteMovie.setValue(
            posterPath,
            forKey: Constants.EntityAttributeKeys.posterPath.rawValue
        )
        
        do {
            try managedContext.save()
            completion(nil)
        } catch {
            completion(error)
        }
        
    }
    
    /// Метод для стягивания данных с CoreData
    public func fetchFavoriteMovies(
        completion: @escaping ( (Result<[FavoriteMovie], Error>) -> Void)
    ) {
        let managedContext = persistentContainer.viewContext
        let fetchData = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        do {
            let favoriteMovies = try managedContext.fetch(fetchData)
            completion(.success(favoriteMovies))
        } catch {
            completion(.failure(error))
        }
    }
    
    
    /// Метод для удаления объекта из CoreData.
    func removeMovieFromFavorites(
        _ movieToDelete: FavoriteMovie,
        completion: @escaping ( (Error?) -> Void)
    ) {
        let managedContext = persistentContainer.viewContext
        managedContext.delete(movieToDelete)
        
        do {
            try managedContext.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    public func fetchRX() -> Observable<[FavoriteMovie]> {
        return Observable<[FavoriteMovie]>.create { [unowned self] observer in
            let managedContext = self.persistentContainer.viewContext
            let fetchData = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
            do {
                let favoriteMovies = try managedContext.fetch(fetchData)
                observer.onNext(favoriteMovies)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
}


