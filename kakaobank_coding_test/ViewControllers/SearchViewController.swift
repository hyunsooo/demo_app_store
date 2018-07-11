//
//  SearchViewController.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 6..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SearchViewControllerDelegate: class {
    func setSearchTextInSearchBar(term: String)
}

class SearchViewController: UIViewController, SearchViewControllerDelegate {

    let hanguelRegx: String = "^[ㄱ-ㅎㅏ-ㅣ가-힣//s]*$"
    let searchUrl: String = "https://itunes.apple.com/search?country=kr&entity=software"
    var searchController: UISearchController?
    
    var isSearching: Bool = false
    
    @IBOutlet var tableView: UITableView!   // 최근 검색어
//    @IBOutlet var tableView2: UITableView!  // 히스토리
//    @IBOutlet var tableView3: UITableView!  // 검색 결과
//    @IBOutlet var searchView: UIView!
    
    var cancelGestureRecognizer: UITapGestureRecognizer?
    
    // 최근 검색어
    var dataSource = [String]()
    
    // 히스토리
    var dataSource2 = [String]()
    
    var dataSource3 = [Model.SearchResult]()
    
    var showTitle: Bool = false
    var selectedModel: Model.SearchResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.clipsToBounds = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        let searchResultsController = SearchResultsViewController()
        searchResultsController.delgate = self
        searchController = UISearchController(searchResultsController: searchResultsController)
        
        searchController?.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController?.searchBar.placeholder = "App Store"
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.searchBarStyle = .prominent
        searchController?.obscuresBackgroundDuringPresentation = true
        searchController?.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource = GlobalState.instance.recentSearch
        tableView.reloadData()
    }
    
    func setSearchTextInSearchBar(term: String) {
        searchController?.searchBar.text = term
        searchController?.isActive = true
        search(term: term)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterTermForSearchText(searchText)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if !GlobalState.instance.recentSearch.contains(searchText) {
            addnAndFetchRecentSearch(term: searchText)
        }
        search(term: searchText)
    }
    
    
    func search(term: String) {
        
        let urlString: String = "\(searchUrl)&term=\(term)"
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 0)
            URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                guard let `self` = self else { return }
                guard let data = data, let _ = response, error == nil else {
                    if let error = error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async { self.alert(error.localizedDescription)}
                    }
                    return
                }
                if !GlobalState.instance.recentSearch.contains(term) {
                    DispatchQueue.main.async { self.addnAndFetchRecentSearch(term: term) }
                } else {
                    if let termIndex = GlobalState.instance.recentSearch.index(of: term) {
                        if termIndex > 9 {
                            GlobalState.instance.recentSearch.remove(at: termIndex)
                            DispatchQueue.main.async {  self.addnAndFetchRecentSearch(term: term) }
                        }
                    }
                }
                (self.searchController?.searchResultsController as? SearchResultsViewController)?.dataSource2 = Model.Results(JSON(data)).results
                }.resume()
        }
    }
    
    func addnAndFetchRecentSearch(term: String) {
        GlobalState.instance.recentSearch.insert(term, at: 0)
        dataSource.insert(term, at: 0)
        tableView.reloadData()
    }
    
    func filterTermForSearchText(_ searchText: String) {
        do {
            let regEx = try NSRegularExpression(pattern: hanguelRegx, options: [])
            let num = regEx.numberOfMatches(in: searchText, options: [], range: NSRange(location: 0, length: searchText.count))
            if num == 0 {
                alert("한글만 입력 가능합니다.")
//                searchView.alpha = 0
//                tableView2.alpha = 0
//                tableView3.alpha = 0
                searchController?.searchBar.text = ""
                searchController?.searchBar.becomeFirstResponder()
            } else {
                (searchController?.searchResultsController as? SearchResultsViewController)?.dataSource = GlobalState.instance.recentSearch.filter { ($0 as NSString).range(of: searchText, options: .caseInsensitive).location != NSNotFound }
//                tableView2.reloadData()
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return dataSource.count > 10 ? 10 : dataSource.count
//        } else if tableView == self.tableView2 {
//            return dataSource2.count
//        }  else if tableView == self.tableView3 {
//            return dataSource3.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
            cell.update(dataSource[indexPath.row])
            return cell
//        } else if tableView == self.tableView2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
//            cell.update(dataSource2[indexPath.row])
//            return cell
//        } else if tableView == self.tableView3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
//            cell.update(dataSource3[indexPath.row])
//            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // search selected data's term
        if tableView == self.tableView {
            let data = dataSource[indexPath.row]
            searchController?.searchBar.text = data
            searchController?.isActive = true
            search(term: data)
        }
//        else if tableView == self.tableView2 {
//            let data = dataSource2[indexPath.row]
//            searchController?.searchBar.text = data
//            searchController?.isActive = true
//            search(term: data)
//        }
//        else if tableView == self.tableView3 {
//            let data = dataSource3[indexPath.row]
//            self.selectedModel = data
//        }
        else { }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 44
        }
//        else if tableView == self.tableView2 {
//            return 60
//        } else if tableView == self.tableView3 {
//            return 310
//        }
        else { return 0 }
    }
}

extension UIViewController {
    func alert(_ message: String) {
        let alertController = UIAlertController(title: "App Store", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
