//
//  RecentSearchCell.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 6..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

protocol CellProtocol: class {
    associatedtype Item
    func update(_ data: Item)
}

class RecentSearchCell: UITableViewCell {
    @IBOutlet var searchTextLabel: UILabel!
    static let identifier: String = "kRecentSearchCell"
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = isHighlighted ? #colorLiteral(red: 0.1725490196, green: 0.4862745098, blue: 0.9647058824, alpha: 1) : .clear
        searchTextLabel.textColor = isHighlighted ? .white : #colorLiteral(red: 0.1725490196, green: 0.4862745098, blue: 0.9647058824, alpha: 1)
    }
}

extension RecentSearchCell: CellProtocol {
    typealias Item = String
    func update(_ data: Item) {
        searchTextLabel.text = data
    }
}
