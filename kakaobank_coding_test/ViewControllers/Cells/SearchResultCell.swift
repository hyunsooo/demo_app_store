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
    @IBOutlet var ratingControl: RatingControl!
    
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
            case 0:
                if let screenshot = URL(string: $0.element) { appThumbnail1.setImage(url: screenshot) }
            case 1:
                if let screenshot = URL(string: $0.element) { appThumbnail2.setImage(url: screenshot) }
            case 2:
                if let screenshot = URL(string: $0.element) { appThumbnail3.setImage(url: screenshot) }
            default:
                break
            }
        }
        appTitleLabel.text = data.trackCensoredName
        appSubTitleLabel.text = data.genres.first
        ratingCountLabel.text = data.userRatingCount.getText()
        ratingControl.setRating(rating: data.averageUserRating) 
    }
    
}

extension Int {
    func getText() -> String {
        let value = self
        var text: String = "\(value)"
        guard text.count > 3 else { return text }
        text = "\(Int(Double(value) / pow(10.0, Double(text.count - 1 > 4 ? 4 : text.count - 1)))).\((text as NSString).substring(with: NSRange(location: text.count - 1 > 4 ? text.count - 4 : 1, length: 2)))"
        if text.count == 4 { text += "천" }
        else { text += "만" }
        return text
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

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

