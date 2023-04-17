//
//  HomeViewController.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func configureMoviesCollectionView() {
        moviesCollectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )
        
        viewModel.moviesObservable
            .bind(to: moviesCollectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier)
            ) { index, movie, cell in
                guard let cell = cell as? MovieCollectionViewCell else {
                    fatalError()
                }
                cell.setup(with: movie)
            }
            .disposed(by: disposeBag)
        
        moviesCollectionView.rx
            .itemSelected
            .bind { ip in
                print(ip.row)
            }
            .disposed(by: disposeBag)
        
        moviesCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    private func updateUI() {
        view.addSubview(moviesCollectionView)
        moviesCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchMovies()
        updateUI()
        configureMoviesCollectionView()
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.bounds.width,
            height: view.bounds.height / 5
        )
    }
}
