//
//  FavoriteMoviesViewController.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteMoviesViewController: UIViewController {
    private let viewModel = FavoriteMoviesViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var favoriteMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func updateUI() {
        view.addSubview(favoriteMoviesCollectionView)
        favoriteMoviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    
    
    private func configureFavoriteMoviesCollectionView() {
        print("coll view")
        favoriteMoviesCollectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )
        
            
        viewModel.favoriteMoviesObservable
            .bind(
                to: favoriteMoviesCollectionView.rx.items(
                    cellIdentifier: MovieCollectionViewCell.identifier
                )) { index, movie, cell in
                    print("CONFIG")

                    guard let cell = cell as? MovieCollectionViewCell else { return }
                    
                    let item = Item(
                        id: movie.id,
                        rank: movie.rank,
                        title: movie.title, fullTitle: movie.fullTitle,
                        year: movie.year,
                        posterPath: movie.posterPath,
                        crew: movie.crew,
                        rating: movie.rating,
                        ratingCount: movie.ratingCount
                    )
                    cell.configure(with: item)
                }
                .disposed(by: disposeBag)
        
        /// Установка `delegate` через `rx`
        favoriteMoviesCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFavoriteMoviesCollectionView()
        updateUI()
        viewModel.fetxh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetxh()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout extension
extension FavoriteMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.bounds.width,
            height: view.bounds.height / 4.2
        )
    }
    
}
