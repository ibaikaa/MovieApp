//
//  MoviesCollectionView.swift
//  MovieApp
//
//  Created by ibaikaa on 19/4/23.
//

import UIKit

final class MoviesCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumLineSpacing = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MoviesCollectionView: UICollectionView {
    init() {
        let layout = MoviesCollectionViewLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .clear
        register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
