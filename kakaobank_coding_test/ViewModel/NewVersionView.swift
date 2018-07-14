//
//  NewVersionView.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 14..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class NewVersionView: UIView {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseNotesLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var versionHistoryButton: UIButton!
    @IBAction func showMoreReleaseNote() {
        self.alpha = 0.5
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.releaseNotesLabel.numberOfLines = 0
            self.releaseNotesLabel.layoutIfNeeded()
            self.moreButton.alpha = 0
        }, completion: nil)
    }
}

extension NewVersionView: CellProtocol {
    typealias Item = Model.SearchResult
    func update(_ data: Model.SearchResult) {
        versionLabel.text = "버전 \(data.version)"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let descriptionAttribute: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 15), .paragraphStyle: paragraphStyle]
        releaseNotesLabel.attributedText = NSAttributedString(string: data.releaseNotes, attributes: descriptionAttribute)
        releaseNotesLabel.sizeToFit()
        
        let calendar = NSCalendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: formatter.date(from: data.currentVersionReleaseDate) ?? Date())
        let components = calendar.dateComponents([.day], from: date2, to: date1)
    
        if let diffDay = components.day {
            if diffDay == 0 { releaseDateLabel.text = "오늘" }
            else if diffDay < 32 && diffDay > 0 {
                releaseDateLabel.text = "\(diffDay)일 전"
            } else if diffDay > 31 && diffDay < 365 {
                releaseDateLabel.text = "\(diffDay / 30)달 전"
            } else {
                releaseDateLabel.text = "\(diffDay / 365)년 전"
            }
        }
        
    }
}
