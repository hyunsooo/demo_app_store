//
//  ThumbnailsCell.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 12..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class ThumbnailsCell: UICollectionViewCell, CellProtocol {
    
    @IBOutlet var thumbnailImageView: UIImageView!
    typealias Item = String
    func update(_ data: String) {
        if let url = URL(string: data) { thumbnailImageView.setImage(url: url) }
    }
}

