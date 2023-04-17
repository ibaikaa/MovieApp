//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import UIKit
import SnapKit
import PaddingLabel
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
    static let identifier = String(describing: MovieTableViewCell.self)
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var crewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var yearReleasedLabel: UILabel = {
        let label = PaddingLabel()
        label.textColor = .black
        label.backgroundColor = .systemGray5
        label.font = UIFont(name: "AvenirNext-Regular", size: 10)
        label.layer.cornerRadius = 6
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = PaddingLabel()
        label.textColor = .black
        label.backgroundColor = .systemGray5
        label.font = UIFont(name: "AvenirNext-Regular", size: 10)
        label.layer.cornerRadius = 6
        return label
    }()
    
    private func setupSubviews() {
        addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        addSubview(movieNameLabel)
        movieNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(posterImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        addSubview(crewLabel)
        crewLabel.snp.makeConstraints { make in
            make.top.equalTo(movieNameLabel.snp.bottom).offset(10)
            make.left.equalTo(posterImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(yearReleasedLabel)
        yearReleasedLabel.snp.makeConstraints { make in
            make.top.equalTo(crewLabel.snp.bottom).offset(10)
            make.left.equalTo(posterImageView.snp.right).offset(10)
        }
        
        addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(crewLabel.snp.bottom).offset(10)
            make.left.equalTo(yearReleasedLabel.snp.right).offset(15)
        }
    }
    
    public func setup(with model: Item) {
        posterImageView.kf.setImage(with: URL(string: model.image ?? "" ))
        movieNameLabel.text = model.title
        crewLabel.text = model.crew
        yearReleasedLabel.text = model.year
        ratingLabel.text = model.rating
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviews()
    }
    
}
