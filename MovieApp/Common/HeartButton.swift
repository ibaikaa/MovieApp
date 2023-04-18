//
//  HeartButton.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import UIKit

/// Кастомная кнопка с анимацией лайка.
final class HeartButton: UIButton {
    private let unlikedImage = UIImage(systemName: "heart")
    private let likedImage = UIImage(systemName: "heart.fill")
    
    public var isLiked = false {
        didSet {
            let newImage = isLiked ? likedImage : unlikedImage
            tintColor = isLiked ? .red : .white
            setImage(newImage, for: .normal)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .white
        setImage(unlikedImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func flipLikedState() {
        isLiked.toggle()
        animate()
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = self.transform.scaledBy(x: 0.8, y: 0.8)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
    
}
