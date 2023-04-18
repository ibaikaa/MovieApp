//
//  FavoriteMoviesViewController.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

final class FavoriteMoviesViewController: UIViewController {
    // MARK: - Свойства
    private let viewModel = FavoriteMoviesViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI-элементы
    
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
                guard let `self` = self else { return }
                let vc = MovieDetailedViewController()
                vc.viewModel = MovieDetailedViewModel(
                    movie: favoriteMovie.toMovieItem(),
                    detailedVCForFavoriteMovie: true
                )
                self.navigationController?.pushViewController(vc, animated: true)
            } onError: { error in
                self.showInfoAlert(title: "Error", message: error.localizedDescription)
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
    }
    
    // MARK: - View, в случае если нет данных.
    private var noDataAnimationView: LottieAnimationView = .init()
    private func setupNoDataAnimationView() {
        guard let filePath = Bundle.main.path(
            forResource: Constants.LottieAnimationJSONFileNames.fallingPopcorn.rawValue,
            ofType: Constants.sharedInstance.JSON
        ) else { return }
        
        noDataAnimationView.animation = LottieAnimation.filepath(filePath)
        noDataAnimationView.loopMode = .loop
        noDataAnimationView.animationSpeed = 2.0
        noDataAnimationView.contentMode = .scaleToFill

        noDataAnimationView.play()
    }
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ratingColor
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.text = "No Favorite Movies yet 😞"
        label.textAlignment = .center
        return label
    }()
    
    /// Метод для установки констрейнтов.
    private func setupSubviews() {
        view.addSubview(favoriteMoviesCollectionView)
        favoriteMoviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(noDataAnimationView)
        noDataAnimationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(view.bounds.width / 2)
        }
        
        view.addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints { make in
            make.top.equalTo(noDataAnimationView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - ViewModel
    private func initViewModel() {
        viewModel.favoriteMoviesObservable
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] movies in
                guard let movies = movies.element, movies.isEmpty else {
                    self?.noDataAnimationView.isHidden = true
                    self?.noDataLabel.isHidden = true
                    return
                }
                self?.noDataAnimationView.isHidden = false
                self?.noDataLabel.isHidden = false
            }
            .disposed(by: disposeBag)
        
        viewModel.errorObservable
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] error in
                if let error = error.element {
                    self?.showInfoAlert(title: "Error", message: error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupSubviews()
        setupNoDataAnimationView()
        configureFavoriteMoviesCollectionView()
        configureSearchController()
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

