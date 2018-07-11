//
//  AppDetailViewController.swift
//  kakaobank_coding_test
//
//  Created by FURSYS on 2018. 7. 9..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppDetailViewController: UIViewController {

    var model: Model.SearchResult?
    
    @IBOutlet var appIcon: UIImageView!
    @IBOutlet var appTitleLabel: UILabel!
    @IBOutlet var appSubTitleLabel: UILabel!
    @IBOutlet var ratingControl: RatingControl!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingUserCountLabel: UILabel!
    @IBOutlet var categoryNumberLabel: UILabel!
    @IBOutlet var categoryNameLabel: UILabel!
    @IBOutlet var useAgingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        setting()
    }

    func setting() {
        guard let model = model else {
            alert("데이터가 없습니다.")
            self.navigationController?.popViewController(animated: true)
            return
        }
        if let iconUrl = URL(string: model.artworkUrl100) { appIcon.setImage(url: iconUrl) }
        appTitleLabel.text = model.trackCensoredName
        appSubTitleLabel.text = model.sellerName
        ratingControl.setRating(rating: model.averageUserRating)
        ratingLabel.text = "\(model.averageUserRating)"
        ratingUserCountLabel.text = "\(model.userRatingCount.getText())개의 평가"
        categoryNameLabel.text = model.genres.first
        useAgingLabel.text = model.trackContentRating
        categoryNumberLabel.text = "#1"
    }
    
    
    // same data
//    func lookup(trackId: Int) {
//        if let url = URL(string: "https://itunes.apple.com/lookup?id=\(trackId)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
//            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 0)
//            URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
//                guard let `self` = self else { return }
//                guard let data = data, let _ = response, error == nil else {
//                    if let error = error {
//                        print(error.localizedDescription)
//                        DispatchQueue.main.async { self.alert(error.localizedDescription)}
//                    }
//                    return
//                }
//
//            }.resume()
//        }
//    }
    
}
