//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieListViewController: UIViewController {
    // MARK: - Свойства
    private let viewModel = MovieListViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UISearchController
    private let moviesSearchController = UISearchController(searchResultsController: nil)
    
    /// Метод для настройки `moviesSearchController'а`.
    private func configureSearchController() {
        // Стиль searchBar'a
        moviesSearchController.searchBar.barStyle = .black
        // Placeholder
        moviesSearchController.searchBar.searchTextField.placeholder = "Search movie by name"
        
        /// Установка `searchController'а` для `navigationItem`
        navigationItem.searchController = moviesSearchController
        
        // Установка, чтоб при скролле было видно и title и поисковик.
        moviesSearchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - UICollectionView
    private let moviesCollectionView = MoviesCollectionView()
    
    /// Метод для установки констрейнтов.
    private func setupSubviews() {
        view.addSubview(moviesCollectionView)
        moviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
        
    /// Метод для связывания `moviesCollectionView` с данными с `viewModel`.
    private func bindCollectionView() {
        viewModel.moviesObservable
            .bind(to: moviesCollectionView.rx.items(
                cellIdentifier: MovieCollectionViewCell.identifier
            )) { index, movie, cell in
                guard let cell = cell as? MovieCollectionViewCell else {
                    return
                }
                cell.configure(with: movie)
            }
            .disposed(by: disposeBag)
    }
    
    /// Метод для связывания `moviesCollectionView` с данными с `viewModel`.
    private func handleCellSelection() {
        moviesCollectionView.rx.modelSelected(Item.self)
            .subscribe { [weak self] movie in
                guard let `self` = self else { return }
                let vc = MovieDetailedViewController()
                vc.viewModel = MovieDetailedViewModel(
                    movie: movie,
                    detailedVCForFavoriteMovie: false
                )
                self.navigationController?.pushViewController(vc, animated: true)
            } onError: { error in
                self.showInfoAlert(title: "Error", message: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    /// Метод для установки делегата  для `moviesCollectionView`.
    private func setCollectionViewDelegate() {
        moviesCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Приватные методы
    private func configureMoviesCollectionView() {
        bindCollectionView()
        handleCellSelection()
        setCollectionViewDelegate()
        setupSubviews()
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getMovies()
        configureSearchController()
        configureMoviesCollectionView()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout extension
extension MovieListViewController: UICollectionViewDelegateFlowLayout {
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
