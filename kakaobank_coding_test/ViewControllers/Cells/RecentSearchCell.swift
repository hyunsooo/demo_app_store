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
        backgroundColor = isHighlighted ? .blue : .clear
        searchTextLabel.textColor = isHighlighted ? .white : .blue
    }
}

extension RecentSearchCell: CellProtocol {
    typealias Item = Model.RecentSearch
    func update(_ data: Model.RecentSearch) {
        searchTextLabel.text = data.term
    }
}
