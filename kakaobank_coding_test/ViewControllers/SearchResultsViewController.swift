//
//  SearchResultsViewController.swift
//  kakaobank_coding_test
//
//  Created by FURSYS on 2018. 7. 11..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    var dataSource = [String]()
    var dataSource2 = [Model.SearchResult]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableView2: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return
    }
}
