//
//  MovieDetailedViewController.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import UIKit
import Cosmos
import SnapKit
import Kingfisher

final class MovieDetailedViewController: UIViewController {
    // MARK: - Свойства
    public var viewModel: MovieDetailedViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            rankLabel.text = "Rating: \(viewModel.getRank())"
            viewModel.setPosterImage(for: posterImageView)
            movieInfoLabel.text = viewModel.getFullTitle()
            ratingStarsView.rating = viewModel.getRatingValue()
            ratingStarsView.text = viewModel.getRating()
            ratingCountLabel.text = viewModel.getRatingCount()
            crewLabel.text = "Crew: \(viewModel.getCrew())"
        }
    }
    
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.text = "Rating: 1"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    private lazy var movieInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 24)
        label.text = "Movie name (2009) "
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var ratingStarsView: CosmosView = {
        var settings = CosmosSettings()
        
        // Шрифт и цвет для текста
        settings.textFont = UIFont(name: "AvenirNext-Regular", size: 16)!
        settings.textColor = .ratingColor
        
        // Настройка звездочек
        settings.fillMode = .precise
        
        // Настройка цветов для звездочек
        settings.filledColor = .ratingColor
        settings.emptyBorderColor = .ratingColor
        settings.filledBorderColor = .ratingColor
        
        // Создание CosmosView
        let cosmosView = CosmosView(settings: settings)
        
        // Отключение интерактива с пользователями
        cosmosView.isUserInteractionEnabled = false
        
        return cosmosView
    }()
    
    private lazy var ratingCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textColor = .systemGray4
        return label
    }()
    
    private lazy var crewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Italic", size: 16)
        label.textColor = .systemGray4
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var watchTrailerButton: UIButton = {
        let watchTrailerAction = UIAction { action in
            print("Watch trailer")
        }
        
        let button = UIButton(primaryAction: watchTrailerAction)
        button.setTitle("Watch trailer", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Методы
    private func updateUI() {
        view.backgroundColor = .movieViewBackgroundColor

        view.addSubview(rankLabel)
        rankLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(rankLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.bounds.width/2)
            make.height.equalTo(view.bounds.height/3)
        }
        
        view.addSubview(movieInfoLabel)
        movieInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(ratingStarsView)
        ratingStarsView.snp.makeConstraints { make in
            make.top.equalTo(movieInfoLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
        }
        
        view.addSubview(ratingCountLabel)
        ratingCountLabel.snp.contentHuggingHorizontalPriority = ratingStarsView.snp.contentHuggingHorizontalPriority - 1
        ratingCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ratingStarsView.snp.centerY)
            make.left.equalTo(ratingStarsView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(crewLabel)
        crewLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStarsView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(watchTrailerButton)
        watchTrailerButton.snp.makeConstraints { make in
            make.top.equalTo(crewLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
            make.height.equalTo(40)
        }
    }
    
    private func configureNavigationBar() {
        title = "Detail Movie"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let addToFavoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(didTapAddToFavoritesButton)
        )
        navigationItem.rightBarButtonItem = addToFavoritesButton
    }
    
    @objc
    private func didTapAddToFavoritesButton() {
        print("Add to favorites")
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureNavigationBar()
    }
    
}

