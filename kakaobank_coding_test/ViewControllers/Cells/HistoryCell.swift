//
//  HistoryCell.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 8..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet var historyTextLabel: UILabel!
    static let identifier: String = "kHistoryCell"
    
}

extension HistoryCell: CellProtocol {
    typealias Item = String
    func update(_ data: Item) {
        historyTextLabel.text = data
    }
}
