//
//  SearchResultCell.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 8..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet var appIconImageView: UIImageView!
    @IBOutlet var appTitleLabel: UILabel!
    @IBOutlet var appSubTitleLabel: UILabel!
    @IBOutlet var ratingCountLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var appThumbnail1: UIImageView!
    @IBOutlet var appThumbnail2: UIImageView!
    @IBOutlet var appThumbnail3: UIImageView!
    static let identifier: String = "kSearchResultCell"
    
    override func prepareForReuse() {
        appIconImageView.image = nil
        appThumbnail1.image = nil
        appThumbnail2.image = nil
        appThumbnail3.image = nil
    }
}

extension SearchResultCell: CellProtocol {
    typealias Item = Model.SearchResult
    func update(_ data: Item) {
        if let appIcon = URL(string: data.artworkUrl100) { appIconImageView.setImage(url: appIcon) }
        data.screenshotUrls.enumerated().forEach {
            switch $0.offset {
            case 1:
                if let screenshot = URL(string: $0.element) { appThumbnail1.setImage(url: screenshot) }
            case 2:
                if let screenshot = URL(string: $0.element) { appThumbnail2.setImage(url: screenshot) }
            case 3:
                if let screenshot = URL(string: $0.element) { appThumbnail3.setImage(url: screenshot) }
            default:
                break
            }
        }
        appTitleLabel.text = data.trackCensoredName
        appSubTitleLabel.text = data.genres.first
        ratingCountLabel.text = "\(data.userRatingCount)"
    }
    
}

extension UIImageView {
    func setImage(url: URL) {
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 0
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            guard let data = data, let _ = response, error == nil else {
                if let error = error { NSLog(error.localizedDescription) }
                return
            }
            DispatchQueue.main.async { self.image = UIImage(data: data) }
        }.resume()
    }
}

