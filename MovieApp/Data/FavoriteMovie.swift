//
//  FavoriteMovie.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import CoreData

@objc(FavoriteMovie)
class FavoriteMovie: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var fullTitle: String
    @NSManaged var title: String
    @NSManaged var year: String
    @NSManaged var rank: String
    @NSManaged var rating: String
    @NSManaged var ratingCount: String
    @NSManaged var crew: String
    @NSManaged var posterPath: String
}
