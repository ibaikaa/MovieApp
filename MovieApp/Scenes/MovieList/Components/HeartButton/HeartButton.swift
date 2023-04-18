//
//  HeartButton.swift
//  MovieApp
//
//  Created by ibaikaa on 18/4/23.
//

import UIKit

/// Кастомная кнопка с анимацией лайка.
final class HeartButton: UIButton {
    private var isLiked = false
    
    private let unlikedImage = UIImage(systemName: "heart")
    private let likedImage = UIImage(systemName: "heart.fill")
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .white
        setImage(unlikedImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func flipLikedState() {
        isLiked = !isLiked
        animate()
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isLiked ? self.likedImage : self.unlikedImage
            self.tintColor = self.isLiked ? .red : .white
            self.transform = self.transform.scaledBy(x: 0.8, y: 0.8)
            self.setImage(newImage, for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
