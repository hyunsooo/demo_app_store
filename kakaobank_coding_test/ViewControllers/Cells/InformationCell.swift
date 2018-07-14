//
//  InformationCell.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 14..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension InformationCell: CellProtocol {
    typealias Item = (String, String)
    func update(_ data: Item) {
        categoryLabel.text = data.0
        informationLabel.text = data.1
    }
}
