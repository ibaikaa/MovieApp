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
    // MARK: - Свойства
    private let viewModel = FavoriteMoviesViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UISearchController
    private let favoriteMoviesSearchController = UISearchController(searchResultsController: nil)
    
    /// Метод для настройки `favoriteMoviesSearchController'а`.
    private func configureSearchController() {
        // Стиль searchBar'a
        favoriteMoviesSearchController.searchBar.barStyle = .black
        // Placeholder
        favoriteMoviesSearchController.searchBar.searchTextField.placeholder = "Search movie by name"
        
        /// Установка `searchController'а` для `navigationItem`
        navigationItem.searchController = favoriteMoviesSearchController
        
        // Установка, чтоб при скролле было видно и title и поисковик.
        favoriteMoviesSearchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - UICollectionView
    private let favoriteMoviesCollectionView = MoviesCollectionView()
    
    /// Метод для установки констрейнтов.
    private func setupSubviews() {
        view.addSubview(favoriteMoviesCollectionView)
        favoriteMoviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    /// Метод для связывания `favoriteMoviesCollectionView` с данными с `viewModel`.
    private func bindCollectionView() {
        viewModel.favoriteMoviesObservable
            .bind(to: favoriteMoviesCollectionView.rx.items(
                cellIdentifier: MovieCollectionViewCell.identifier
            )) { index, favoriteMovie, cell in
                guard let cell = cell as? MovieCollectionViewCell else { return }
                cell.configure(with: favoriteMovie.toMovieItem())
            }
            .disposed(by: disposeBag)
    }
    
    /// Метод для связывания `favoriteMoviesCollectionView` с данными с `viewModel`.
    private func handleCellSelection() {
        favoriteMoviesCollectionView.rx
            .modelSelected(FavoriteMovie.self)
            .subscribe { [weak self] favoriteMovie in
                guard let self = self else { return }
                let vc = MovieDetailedViewController()
                vc.viewModel = MovieDetailedViewModel(movie: favoriteMovie.toMovieItem())
                self.navigationController?.pushViewController(vc, animated: true)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    /// Метод для установки делегата  для `favoriteMoviesCollectionView`.
    private func setCollectionViewDelegate() {
        favoriteMoviesCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// Метод для конфигурации `favoriteMoviesCollectionView`.
    private func configureFavoriteMoviesCollectionView() {
        bindCollectionView()
        handleCellSelection()
        setCollectionViewDelegate()
        setupSubviews()
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFavoriteMoviesCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteMovies()
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

