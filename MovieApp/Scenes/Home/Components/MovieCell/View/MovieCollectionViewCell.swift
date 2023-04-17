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
import RxSwift

final class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: MovieCollectionViewCell.self)
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var backgroundViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .movieViewBackgroundColor
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var movieNameLabel: UILabel = {
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
    
    private lazy var crewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private lazy var rankIconLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.isHidden = true
        return label
    }()
    
    private lazy var saveDataButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        return button
    }()
    
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
        
        addSubview(movieNameLabel)
        movieNameLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundViewContainer.snp.top).offset(20)
            make.left.equalTo(posterImageView.snp.right).offset(20)
            make.right.equalTo(backgroundViewContainer.snp.right).offset(-30)
        }
        
        addSubview(ratingStarsView)
        ratingStarsView.snp.makeConstraints { make in
            make.top.equalTo(movieNameLabel.snp.bottom).offset(10)
            make.left.equalTo(posterImageView.snp.right).offset(20)
            make.right.equalTo(backgroundViewContainer.snp.right).offset(-10)
        }
        
        addSubview(crewLabel)
        crewLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStarsView.snp.bottom).offset(20)
            make.left.equalTo(posterImageView.snp.right).offset(20)
            make.right.equalTo(backgroundViewContainer.snp.right).offset(-30)
        }
        
        addSubview(rankIconLabel)
        rankIconLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundViewContainer.snp.top).offset(-10)
            make.right.equalTo(backgroundViewContainer.snp.right).offset(-10)
        }
        
        
        addSubview(saveDataButton)
        saveDataButton.snp.makeConstraints { make in
            make.right.equalTo(backgroundViewContainer.snp.right).offset(-10)
            make.bottom.equalTo(backgroundViewContainer.snp.bottom).offset(-10)
            make.width.height.equalTo(30)
        }
        
    }
    
    private func setRankIconForTopThreeMovies(place: Int) -> String {
        switch place {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return ""
        }
    }
    
    private func getDirector(crew: String) -> String {
        guard !crew.isEmpty else { return "No Data" }
        let firstPerson = crew.components(separatedBy: ",")[0]
        print(firstPerson)
        let firstPersonName = firstPerson.components(separatedBy: " ")[0]
        let firstPersonLastName = firstPerson.components(separatedBy: " ")[1]
        return firstPersonName + " " + firstPersonLastName
    }
    
    public func setup(with model: Item) {
        posterImageView.kf.setImage(with: URL(string: model.image ?? "" ))
        movieNameLabel.text = "\(model.title ?? "Movie Name") (\(model.year ?? "0000"))"
        crewLabel.text = "Director: \(getDirector(crew: model.crew ?? ""))"
        
        if let rank = model.rank, let rankInt = Int(rank), Array(1...3).contains(rankInt) {
            rankIconLabel.text = setRankIconForTopThreeMovies(place: rankInt)
            rankIconLabel.isHidden = false
        }
        
        guard
            let rating = model.rating,
            let rating = Double(rating)
        else {
            ratingStarsView.rating = 5
            ratingStarsView.text = "No Data"
            return
        }
        
        ratingStarsView.rating = rating / 2
        ratingStarsView.text = model.rating
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
   
    }
    
}
