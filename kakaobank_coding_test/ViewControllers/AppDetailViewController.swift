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
    @IBOutlet var descrtiptionLabel: UILabel!
    
    @IBOutlet var thumbnailsCollectionView: UICollectionView!
    private var indexOfCellBeforeDragging = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        setting()
        thumbnailsCollectionView.reloadData()
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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let descriptionAttribute: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 15), .paragraphStyle: paragraphStyle]
        descrtiptionLabel.attributedText = NSAttributedString(string: model.description, attributes: descriptionAttribute)
        appTitleLabel.sizeToFit()
        descrtiptionLabel.sizeToFit()
    }
    
}

extension AppDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.screenshotUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailsCell", for: indexPath) as! ThumbnailsCell
        if let model = model {
            cell.update(model.screenshotUrls[indexPath.row])
        }
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let index = indexOfMajorCell()
        if let model = model {
        let dataSourceCount = model.screenshotUrls.count
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = index == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
            if didUseSwipeToSkipCell {
                let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
                let toValue = 240 * CGFloat(snapToIndex)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    scrollView.layoutIfNeeded()
                }, completion: nil)
            } else {
                thumbnailsCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
                if index < dataSourceCount - 1 {
                    scrollView.contentOffset.x -= 10
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    private func indexOfMajorCell() -> Int {
        let proportionalOffset = thumbnailsCollectionView.contentOffset.x / 240
        return Int(round(proportionalOffset))
    }
}
