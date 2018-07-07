//
//  TapBarViewController.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 6..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class TapBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 4   // set default initial controller : search view controller
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
