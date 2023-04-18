//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import CoreData
import UIKit
import RxSwift
import RxCocoa

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var persistentContainer: NSPersistentContainer = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve App Delegate")
        }
        
        let container = appDelegate.persistentContainer
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    private init() { }
    
    func saveFavoriteMovie(title: String) -> Completable {
        return Completable.create { [unowned self] completable in
            let context = self.persistentContainer.viewContext
            
            guard let entity = NSEntityDescription.entity(
                forEntityName: "Movie",
                in: context
            ) else {
                completable(.error(CoreDataError.entityNotFound))
                return Disposables.create()
            }
            
            let favoriteMovie = FavoriteMovie(entity: entity, insertInto: context)
            favoriteMovie.setValue(title, forKey: "title")
            
            do {
                try context.save()
                completable(.completed)
            } catch let error as NSError {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func fetchFavoriteMovies() -> Observable<[FavoriteMovie]> {
        return Observable.create { [unowned self] observer in
            let context = self.persistentContainer.viewContext
            let fetchData = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            
            do {
                let favoriteMovies = try context.fetch(fetchData) as? [FavoriteMovie] ?? []
                observer.onNext(favoriteMovies)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
        
}


