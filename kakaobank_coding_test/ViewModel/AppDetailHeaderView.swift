//
//  AppDetailHeaderView.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 9..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class AppDetailHeaderView: UIStackView {
    
    @IBOutlet var appIcon: UIImageView!
    @IBOutlet var appTitleLabel: UILabel!
    @IBOutlet var appSubTitleLabel: UILabel!
    @IBOutlet var ratingControl: RatingControl!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingUserCountLabel: UILabel!
    @IBOutlet var categoryNumberLabel: UILabel!
    @IBOutlet var categoryNameLabel: UILabel!
    @IBOutlet var useAgingLabel: UILabel!
    
}

extension AppDetailHeaderView: CellProtocol {
    typealias Item = Model.SearchResult
    func update(_ data: Model.SearchResult) {
        if let iconUrl = URL(string: data.artworkUrl100) { appIcon.setImage(url: iconUrl) }
        appTitleLabel.text = data.trackCensoredName
        appSubTitleLabel.text = data.sellerName
        ratingControl.setRating(rating: data.averageUserRating)
        ratingLabel.text = "\(data.averageUserRating)"
        ratingUserCountLabel.text = "\(data.userRatingCount.getText())개의 평가"
        categoryNameLabel.text = data.genres.first
        useAgingLabel.text = data.trackContentRating
        categoryNumberLabel.text = "#1"
        appTitleLabel.sizeToFit()
    }
}
