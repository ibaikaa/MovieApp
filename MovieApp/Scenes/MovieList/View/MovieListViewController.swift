//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class MovieListViewController: UIViewController {
    // MARK: - Приватные свойства
    private let viewModel = MovieListViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // UISearchController
    private let moviesSearchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Приватные методы
    private func configureMoviesCollectionView() {
        // Регистрация кастомной ячейки
        moviesCollectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )
        
        /// Связывание данных для `moviesCollectionView` от `viewModel`
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
        
        /// Отлавливание нажатия на ячейку через `rx`
        moviesCollectionView.rx
            .modelSelected(Item.self)
            .subscribe { movie in
                let vc = MovieDetailedViewController()
                vc.viewModel = MovieDetailedViewModel(movie: movie)
                self.navigationController?.pushViewController(vc, animated: true)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        
        /// Установка `delegate` через `rx`
        moviesCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// Метод для установки констрейнтов.
    private func updateUI() {
        view.addSubview(moviesCollectionView)
        moviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    /// Метод для настройки `moviesSearchController'а`.
    private func configureSearchController() {
        moviesSearchController.searchBar.barStyle = .black // Стиль searchBar'a
        
        moviesSearchController.searchBar.searchTextField.placeholder = "Search movie by name" // Placeholder
        
        /// Установка `searchController'а` для `navigationItem`
        navigationItem.searchController = moviesSearchController
        
        // Установка, чтоб при скролле было видно и title и поисковик.
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getMovies()
        configureSearchController()
        configureMoviesCollectionView()
        updateUI()
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
