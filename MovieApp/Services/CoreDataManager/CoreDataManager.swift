//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve App Delegate")
        }
        
        let container = appDelegate.persistentContainer
        
        return container
    }()
    
    private init() { }
    
    func saveFavoriteMovie(
        title: String,
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
        favoriteMovie.setValue(title, forKey: "title")
        
        do {
            try managedContext.save()
            completion(nil)
            print("Успешно сохранено! \(title)")
        } catch {
            completion(error)
        }
    }
    
    func fetchFavoriteMovies(
        completion: @escaping ( (Result<[FavoriteMovie], Error>) -> Void)
    ) {
        let managedContext = persistentContainer.viewContext
        let fetchData = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        do {
            let favoriteMovies = try managedContext.fetch(fetchData)
            completion(.success(favoriteMovies))
            print("Успешно стянул данные.")
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeMovieFromFavorites(
        _ movieToDelete: FavoriteMovie,
        completion: @escaping ( (Error?) -> Void)
    ) {
        let managedContext = persistentContainer.viewContext
        managedContext.delete(movieToDelete)
        
        do {
            try managedContext.save()
            completion(nil)
            print("Успешно удалено! \(movieToDelete.title)")
        } catch {
            completion(error)
        }
    }
        
}


