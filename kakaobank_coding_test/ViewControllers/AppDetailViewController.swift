//
//  AppDetailViewController.swift
//  kakaobank_coding_test
//
//  Created by FURSYS on 2018. 7. 9..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
