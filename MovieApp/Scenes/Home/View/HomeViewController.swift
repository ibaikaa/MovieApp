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
        return tableView
    }()
    
    private func configureMoviesTableView() {
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        viewModel.moviesObservable
            .bind(to: moviesTableView.rx.items(cellIdentifier: MovieTableViewCell.identifier)) { index, movie, cell in
                
                guard let cell = cell as? MovieTableViewCell else { fatalError() }
                cell.setup(with: movie)
                cell.selectionStyle = .none
                
            }
            .disposed(by: disposeBag)
        
        moviesTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupSubviews() {
        view.addSubview(moviesTableView)
        moviesTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchMovies()
        setupSubviews()
        configureMoviesTableView()
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
