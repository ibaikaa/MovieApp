//
//  FavoriteMovie.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import CoreData

@objc(FavoriteMovie)
class FavoriteMovie: NSManagedObject {
    @NSManaged var title: String?
}
