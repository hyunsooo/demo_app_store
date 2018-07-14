//
//  DescriptionView.swift
//  kakaobank_coding_test
//
//  Created by FURSYS on 2018. 7. 13..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class DescriptionView: UIView {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBAction func showMoreDescription() {
        self.alpha = 0.5
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.descriptionLabel.numberOfLines = 0
            self.descriptionLabel.layoutIfNeeded()
            self.moreButton.alpha = 0
        }, completion: nil)
    }
}

extension DescriptionView: CellProtocol {
    typealias Item = Model.SearchResult
    func update(_ data: Model.SearchResult) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let descriptionAttribute: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 15), .paragraphStyle: paragraphStyle]
        descriptionLabel.attributedText = NSAttributedString(string: data.description, attributes: descriptionAttribute)
        descriptionLabel.sizeToFit()
        
        moreButton.isHidden = !isLongText(text: data.description)
    }
}

func isLongText(text: String) -> Bool {
    let label = UILabel()
    label.numberOfLines = 0
    
    let rect = CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = text.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: label.font], context: nil)
    
    return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight)) > 3
}
