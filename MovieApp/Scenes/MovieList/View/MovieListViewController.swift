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

    // MARK: - UI-элементы
    
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
    
    /// Метод для конфигурации `moviesCollectionView`.
    private func configureMoviesCollectionView() {
        bindCollectionView()
        handleCellSelection()
        setCollectionViewDelegate()
    }
    
    // MARK: - loadingView: UIActivityIndicatorView
    private var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()
    
    private func showLoadingIndicator() {
        loadingView.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingView.stopAnimating()
    }
    
    // MARK: - TryAgainButton
    private lazy var tryAgainButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .top
        configuration.imagePadding = 10
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(retry), for: .touchUpInside)

        button.setTitle("Try again", for: .normal)
        button.setImage(UIImage(systemName: "repeat"), for: .normal)
        button.tintColor = .systemGray
        
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        button.isHidden = true
        return button
    }()
    
    @objc func retry() {
        viewModel.getMovies()
        tryAgainButton.isHidden = true
    }

    // MARK: - setupSubviews()
    
    /// Метод для установки констрейнтов для элементов.
    private func setupSubviews() {
        view.addSubview(moviesCollectionView)
        moviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(tryAgainButton)
        tryAgainButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - ViewModel
    
    /// Метод для привязки наблюдаемых свойств к UI.
    private func initViewModel() {
        viewModel.isLoading
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] isLoading in
                guard let `self` = self else { return }
                isLoading ? self.showLoadingIndicator() : self.hideLoadingIndicator()
            }
            .disposed(by: disposeBag)
        
        viewModel.errorObservable
            .observeOn(MainScheduler.instance)
            .subscribe { error in
                if let error = error.element {
                    self.showInfoAlert(title: "Error", message: error.localizedDescription)
                    self.tryAgainButton.isHidden = false
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        viewModel.getMovies()
        configureSearchController()
        configureMoviesCollectionView()
        setupSubviews()
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
