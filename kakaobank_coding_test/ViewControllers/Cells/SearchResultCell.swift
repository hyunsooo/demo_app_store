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
    
}

extension SearchResultCell: CellProtocol {
    typealias Item = Model.SearchResult
    func update(_ data: Item) {
        
    }
}
