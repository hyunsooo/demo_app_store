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
    func setSearchTextInSearchBar(term: String)                     // 검색 바에 텍스트 세팅 & 히스토리 연관검색어 Fetch
    func showDetailView(model: Model.SearchResult)                  // 선택한 앱 정보 상세 화면 푸쉬
}

class SearchViewController: UIViewController, SearchViewControllerDelegate {

    let hanguelRegx: String = "^[ㄱ-ㅎㅏ-ㅣ가-힣\\s]*$"   // 한글 및 띄어쓰기 허용 (띄어쓰기 시, 공백을 +로 치환
    let searchUrl: String = "https://itunes.apple.com/search?country=kr&entity=software"    // 나라: 대한민국(kr), 객체: 소프트웨어
    var searchController: UISearchController?
    var dataSource = [String]()
    var showResultsController: Bool = false         // 검색 바에서 Editing 상태일 때에만 SearchResultsController의 tableView를 보인다.
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.clipsToBounds = true
        
        navigationController?.view.subviews.first?.clipsToBounds = true     // _UINavigationcontrollerPaletteClippingView 대응
        
        settingSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource = GlobalState.instance.recentSearch
        tableView.reloadData()
    }
    
    private func settingSearchController() {
        let searchResultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsController.delgate = self
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController?.searchBar.delegate = self
        searchController?.searchBar.placeholder = "App Store"
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = true
        searchController?.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    // 검색 바에 검색어 세팅 및 검색하기
    func setSearchTextInSearchBar(term: String) {
        showResultsController = true                // to hide tableView in SearchResultsViewController
        searchController?.searchBar.text = term
        searchController?.isActive = true
        search(term: term)
    }
    
    // 앱 상세보기 화면 이동
    func showDetailView(model: Model.SearchResult) {
        guard let appDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppDetailViewController") as? AppDetailViewController else { return }
        appDetailViewController.model = model
        navigationController?.pushViewController(appDetailViewController, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterTermForSearchText(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showResultsController = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        showResultsController = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController?.searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        if !GlobalState.instance.recentSearch.contains(searchText) {
            addnAndFetchRecentSearch(term: searchText)
        }
        search(term: searchText)
    }
    
    
    func search(term: String) {
        guard let searchResultsController = searchController?.searchResultsController as? SearchResultsViewController else { return }
        if showResultsController {
            searchResultsController.view.bringSubview(toFront: searchResultsController.tableView2)
        }
        
        let urlString: String = "\(searchUrl)&term=\(term.replacingOccurrences(of: " ", with: "+"))"
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
                searchResultsController.dataSource2 = Model.Results(JSON(data)).results
                DispatchQueue.main.async {
                    searchResultsController.tableView2.reloadData()
                }
            }.resume()
        }
    }
    
    // 최근 검색어 리스트에 검색어 추가 및 최근 검색어 리스트 리로드
    func addnAndFetchRecentSearch(term: String) {
        GlobalState.instance.recentSearch.insert(term, at: 0)
        dataSource.insert(term, at: 0)
        tableView.reloadData()
    }
    
    func filterTermForSearchText(_ searchText: String) {
        guard let searchResultsController = searchController?.searchResultsController as? SearchResultsViewController else { return }
        if !showResultsController {
            searchResultsController.view.bringSubview(toFront: searchResultsController.tableView)
        }
        do {
            let regEx = try NSRegularExpression(pattern: hanguelRegx, options: [])
            let num = regEx.numberOfMatches(in: searchText, options: [], range: NSRange(location: 0, length: searchText.count))
            if num == 0 {
                alert("한글만 입력 가능합니다.")
                searchController?.searchBar.text = ""
                searchController?.searchBar.becomeFirstResponder()
            } else {
                searchResultsController.dataSource = GlobalState.instance.recentSearch.filter { ($0 as NSString).range(of: searchText, options: .caseInsensitive).location != NSNotFound }
                searchResultsController.tableView.reloadData()
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count > 10 ? 10 : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
        cell.update(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            let data = dataSource[indexPath.row]
            setSearchTextInSearchBar(term: data)
        }
    }
}

extension UIViewController {
    func alert(_ message: String) {
        let alertController = UIAlertController(title: "App Store", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
