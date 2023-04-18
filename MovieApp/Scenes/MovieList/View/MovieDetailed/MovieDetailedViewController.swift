//
//  MovieDetailedViewController.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import UIKit

final class MovieDetailedViewController: UIViewController {
    var viewModel: MovieDetailedViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.getTitle()
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        view.backgroundColor = .movieViewBackgroundColor
    }
    
}

