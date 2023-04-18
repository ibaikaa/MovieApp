//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import UIKit
import SnapKit
import Kingfisher
import Cosmos

final class MovieCollectionViewCell: UICollectionViewCell {
    /// Идентификатор ячейки
    static let identifier = String(describing: MovieCollectionViewCell.self)
  
    // MARK: - UI-элементы.
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    private lazy var backgroundViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .movieViewBackgroundColor
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var movieInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 18)
        label.textColor = .white
        label.numberOfLines = 2
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
    
    private lazy var directorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private lazy var rankEmojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.isHidden = true
        return label
    }()

    // MARK: - setupSubviews(). Метод для установки ограничений (constraints) с использованием инструмента Snapkit.
    private func setupSubviews() {
        addSubview(backgroundViewContainer)
        backgroundViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.right.bottom.equalToSuperview()
        }
        
        addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundViewContainer.snp.top).offset(-20)
            make.left.equalTo(backgroundViewContainer.snp.left).offset(20)
            make.bottom.equalTo(backgroundViewContainer.snp.bottom).offset(-20)
            make.width.equalTo(bounds.width / 3)
        }
        
        addSubview(movieInfoLabel)
        movieInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundViewContainer.snp.top).offset(20)
            make.left.equalTo(posterImageView.snp.right).offset(20)
            make.right.equalTo(backgroundViewContainer.snp.right).offset(-30)
        }
        
        addSubview(ratingStarsView)
        ratingStarsView.snp.makeConstraints { make in
            make.top.equalTo(movieInfoLabel.snp.bottom).offset(10)
            make.left.equalTo(posterImageView.snp.right).offset(20)
            make.right.equalTo(backgroundViewContainer.snp.right).offset(-10)
        }
        
        addSubview(directorNameLabel)
        directorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStarsView.snp.bottom).offset(20)
            make.left.equalTo(posterImageView.snp.right).offset(20)
            make.right.equalTo(backgroundViewContainer.snp.right).offset(-30)
        }
        
        addSubview(rankEmojiLabel)
        rankEmojiLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundViewContainer.snp.top).offset(-5)
            make.right.equalTo(backgroundViewContainer.snp.right).offset(-3)
        }
    }
        
    // MARK: - layoutSubviews().
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
    }
    
    // MARK: - For configuring data for cell.
        
    /**
     Данные (эндпоинт `crew` приходят в виде: "Имя Фамилия (дир.), Актер 1, Актер 2"
     Необходимо получить имя и фамилию режиссера.
     Данный метод решает данную задачу,
     – Возвращает: строку с именем и фамилией режиссера.
     */
    
    private func getDirector(crew: String) -> String {
        // Проверка, не пустая ли строка.
        guard !crew.isEmpty else { return "No Data" }
        // Получение имени и фамилии режисера.
        let firstPerson = crew.components(separatedBy: ",")[0]
        // Получение имени
        let firstPersonName = firstPerson.components(separatedBy: " ")[0]
        // Получение фамилии
        let firstPersonLastName = firstPerson.components(separatedBy: " ")[1]
        // Через конкатенацию возвращаем с пробелом имя и фамилию
        return firstPersonName + " " + firstPersonLastName
    }
    
    /**
     Метод для задания значений для элементов с приходящего параметра `movie` типа` Item`.
     */
    public func configure(with movie: Item) {
        /// Использую `kf` для удобной установки изображения по URL.
        posterImageView.kf
            .setImage(
                with: URL(string: movie.posterPath ?? "" ),
                placeholder: UIImage(systemName: "popcorn.fill")
            )
        
        // Установка значений для лейблов через интерполяцию. Вскрываю опциональные значения через коализию.
        movieInfoLabel.text = "\(movie.title ?? "Movie Name") (\(movie.year ?? "0000"))"
        directorNameLabel.text = "Director: \(getDirector(crew: movie.crew ?? ""))"
        
        /// Попытка получения значения rank типа Int через опциональное связывание и проверка, занимает ли оно 1-3 место.
        if let rank = movie.rank, let rankValue = Int(rank), (1...3).contains(rankValue) {
            rankEmojiLabel.text = rankValue.getRankEmoji()
            rankEmojiLabel.isHidden = false
        } else {
            rankEmojiLabel.isHidden = true
        }
        
        guard
            let rating = movie.rating,
            let ratingValue = Double(rating)
        else {
            ratingStarsView.rating = 0
            ratingStarsView.text = "No Data"
            return
        }
        
        ratingStarsView.rating = ratingValue / 2
        ratingStarsView.text = movie.rating
    }
    
}
