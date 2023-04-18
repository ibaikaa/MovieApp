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
import SafariServices


final class MovieDetailedViewController: UIViewController {
    // MARK: - Свойства
    public var viewModel: MovieDetailedViewModel? {
        // Установка значений для UI-элементов после того, как viewModel инициализировалась.
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
        label.textColor = .white
        return label
    }()
    
    private lazy var crewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Italic", size: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var watchTrailerButton: UIButton = {
        let watchTrailerAction = UIAction { [unowned self] action in
            self.viewModel?.getTrailerURLString(completion: { urlString in
                self.playVideo(urlString: urlString)
            })
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
    
    /// Метод для инициализации свойств viewModel.
    private func initViewModel() {
        viewModel?.showAlert = { [weak self] error in
            self?.showInfoAlert(title: "Error", message: error)
        }
    }
    
    /// Метод `playVideo(urlString: String)`, принимающий строку URL, и если ее можно перевести в URL, через SafariServices открывает окно Safari по ссылки на трейлер.
    private func playVideo(urlString: String) {
        if let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
    
    /// Метод для расстановки ограничений (constraints) для элементов и также задаем фон экрану.
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
    
    private let heartButton = HeartButton()

    ///  Метод для конфигурации навигационной панели сверху.
    private func configureNavigationBar() {
        title = "Detail Movie"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        
        heartButton.addTarget(
            self,
            action: #selector(didTapAddToFavoritesButton),
            for: .touchUpInside
        )
        navigationItem.rightBarButtonItem = heartButton.toBarButtonItem()
    }
    
    @objc
    private func didTapAddToFavoritesButton() {
        heartButton.flipLikedState()
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        updateUI()
        configureNavigationBar()
    }
    
}

