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
        moviesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        
        viewModel.moviesObservable
            .bind(to: moviesTableView.rx.items(cellIdentifier: "MovieCell")) { index, movie, cell in
                
                cell.selectionStyle = .none
                cell.textLabel?.text = movie.title
                
            }
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

