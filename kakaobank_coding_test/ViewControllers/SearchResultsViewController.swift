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
    var delgate: SearchViewControllerDelegate?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableView2: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        definesPresentationContext = true
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tableView ? dataSource.count : dataSource2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
            cell.update(dataSource[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
            cell.update(dataSource2[indexPath.row])
            return cell
        } 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 60
        } else {
            return 310
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        if tableView == self.tableView {
            let data = dataSource[indexPath.row]
            delgate?.setSearchTextInSearchBar(term: data)
        } else {
            delgate?.showDetailView(model: dataSource2[indexPath.row])
        }
    }
}

