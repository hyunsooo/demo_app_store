//
//  RatingControl.swift
//  kakaobank_coding_test
//
//  Created by FURSYS on 2018. 7. 9..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {
    // width == height
    @IBInspectable var starSize: CGFloat = 20
    
    @IBOutlet var emptyStars: [UIImageView]!
    @IBOutlet var stars: [UIImageView]!
    
    override func awakeFromNib() {
        setupStars()
    }
    
    private func setupStars() {
        if starSize != 20 {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.widthAnchor.constraint(equalToConstant: starSize * 5 + 20).isActive = true
            self.heightAnchor.constraint(equalToConstant: starSize).isActive = true
            emptyStars.forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.widthAnchor.constraint(equalToConstant: starSize).isActive = true
                $0.heightAnchor.constraint(equalToConstant: starSize).isActive = true
            }
            stars.forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.widthAnchor.constraint(equalToConstant: starSize).isActive = true
                $0.heightAnchor.constraint(equalToConstant: starSize).isActive = true
            }
            
            self.updateConstraints()
        }
    }
    
    func setRating(rating: Float) {
        for i in 0..<5 {
            let star = stars[i]
            // 3.5
            if rating >= Float(i + 1) {
                star.layer.mask = nil
                star.isHidden = false
            } else if rating > Float(i) && rating < Float(i + 1) {
                let maskLayer = CALayer()
                let maskWidth = CGFloat(rating-Float(i)) * starSize
                let maskHeight = starSize
                maskLayer.frame = CGRect(x: 0, y: 0, width: maskWidth, height: maskHeight)
                maskLayer.backgroundColor = UIColor.black.cgColor
                star.layer.mask = maskLayer
                star.isHidden = false
            } else {
                star.layer.mask = nil
                star.isHidden = true
            }
        }
    }
}

