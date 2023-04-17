//
//  ViewController.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkLayer.shared.getMovieList().subscribe(onNext: { movieGroup in
            print(movieGroup)
        }, onError: { error in
            print(error)
        })
    }
    
    
}

