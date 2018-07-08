//
//  SearchViewController.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 6..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController {

    let hanguelRegx: String = "^[ㄱ-ㅎㅏ-ㅣ가-힣//s]*$"
    let searchUrl: String = "https://itunes.apple.com/search?country=kr&entity=software"
    
    var isSearching: Bool = false
    
    @IBOutlet var searchTitle: UILabel!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchCancelButton: UIButton!
    @IBOutlet var searchTitleTopAnchor: NSLayoutConstraint!
    @IBOutlet var headerViewTopAnchor: NSLayoutConstraint!
    @IBOutlet var searchTextFieldRightAnchor: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!   // 최근 검색어
    @IBOutlet var tableView2: UITableView!  // 히스토리
    @IBOutlet var tableView3: UITableView!  // 검색 결과
    @IBOutlet var headerView: UIView!
    @IBOutlet var searchView: UIView!
    
    let cancelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCancel))
    
    // 최근 검색어
    var dataSource = [String]() {
        didSet {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    // 히스토리
    var dataSource2 = [String]()
    
    var dataSource3 = [Model.SearchResult]() {
        didSet {
            DispatchQueue.main.async { self.tableView3.reloadData() }
        }
    }
    
    var showTitle: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black.withAlphaComponent(0)]
        
        searchTextField.leftViewMode = .always
        let searchImageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        let searchImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        searchImageView.image = #imageLiteral(resourceName: "search")
        searchImageView.center = CGPoint(x: searchImageContainerView.center.x + 5,
                                         y:  searchImageContainerView.center.y)
        searchImageContainerView.addSubview(searchImageView)
        searchTextField.leftView = searchImageContainerView
        
        
        searchTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSearch)))
        searchTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource = GlobalState.instance.recentSearch
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isSearching {
            if scrollView.contentOffset.y > 55 {
                if !showTitle {
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black.withAlphaComponent(1)]
                        self.view.layoutIfNeeded()
                    }, completion: { _ in
                        self.showTitle = true
                    })
                }
                
                scrollView.contentOffset.y = 56
                
            } else {
                if showTitle {
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black.withAlphaComponent(0)]
                        self.view.layoutIfNeeded()
                    }, completion: { _ in
                        self.showTitle = false
                    })
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return dataSource.count > 10 ? 10 : dataSource.count
        } else if tableView == self.tableView2 {
            return dataSource2.count
        }  else if tableView == self.tableView3 {
            return dataSource3.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
            cell.update(dataSource[indexPath.row])
            return cell
        } else if tableView == self.tableView2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
            cell.update(dataSource2[indexPath.row])
            return cell
        } else if tableView == self.tableView3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
            cell.update(dataSource3[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // search selected data's term
        if tableView == self.tableView {
            let data = dataSource[indexPath.row]
            self.searchTextField.text = data
            setAnimation(searchOn: true)
            search(term: data)
        } else if tableView == self.tableView2 {
            let data = dataSource2[indexPath.row]
            self.searchTextField.text = data
            search(term: data)
        } else if tableView == self.tableView3 {
            let data = dataSource3[indexPath.row]
            print(data)
        } else { }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 44
        } else if tableView == self.tableView2 {
            return 60
        } else if tableView == self.tableView3 {
            return 250
        } else { return 0 }
    }
}

extension SearchViewController: UITextFieldDelegate {
    // 한글만 입력
    // tableView2 : 히스토리
    @objc func textChange() {
        guard let value = searchTextField.text else { return }
        do {
            searchView.isHidden = false
            searchView.alpha = 1
            tableView2.isHidden = false
            tableView3.isHidden = true
            dataSource2 = []
            let regEx = try NSRegularExpression(pattern: hanguelRegx, options: [])
            let num = regEx.numberOfMatches(in: value, options: [], range: NSRange(location: 0, length: value.count))
            if num == 0 {
                alert("한글만 입력 가능합니다.")
                searchTextField.text = ""
                searchTextField.becomeFirstResponder()
            } else {
                var history = GlobalState.instance.recentSearch
                value.map { String($0) }.forEach { (character) in
                    if let unicode = UnicodeScalar(character)?.value {
                        let nearSearchInHistory = history.compactMap { (search) -> String? in
                            let searchUnicode = search.unicodeScalars
                            let count = searchUnicode.filter  { $0.value == unicode }.count
                            return count > 0 ? search : nil
                        }
                        dataSource2 = nearSearchInHistory
                    }
                    history = dataSource2
                }
                print(dataSource2)
                tableView2.reloadData()
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let term = textField.text else { return false }
        search(term: term)
        return true
    }
    
    func search(term: String) {
        searchView.isHidden = false
        searchView.alpha = 1
        tableView2.isHidden = true
        tableView3.isHidden = false
        dataSource3 = []
        searchView.removeGestureRecognizer(cancelGestureRecognizer)
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
                    GlobalState.instance.recentSearch.insert(term, at: 0)
                    self.dataSource.insert(term, at: 0)
                } else {
                    if let termIndex = GlobalState.instance.recentSearch.index(of: term) {
                        if termIndex > 9 {
                            GlobalState.instance.recentSearch.remove(at: termIndex)
                            GlobalState.instance.recentSearch.insert(term, at: 0)
                            self.dataSource.insert(term, at: 0)
                        }
                    }
                }
                
                self.dataSource3 = Model.Results(JSON(data)).results
                
                }.resume()
        }
    }
}

extension SearchViewController {
    @objc func handleSearch() { //textfield 탭
        self.searchTextField.becomeFirstResponder()
        setAnimation(searchOn: true)
        searchView.addGestureRecognizer(cancelGestureRecognizer)
    }
    
    @IBAction func handleCancel() {
        self.view.endEditing(true)
        setAnimation(searchOn: false)
        searchView.removeGestureRecognizer(cancelGestureRecognizer)
    }
    
    func setAnimation(searchOn: Bool) {
        self.navigationController?.setNavigationBarHidden(searchOn, animated: false)
        searchView.isHidden = !searchOn
        if !searchOn {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.searchTitleTopAnchor.constant = 20
                self.searchTextFieldRightAnchor.constant = 0
                self.headerViewTopAnchor.constant = 0
                self.searchTitle.alpha = 1
                self.searchCancelButton.alpha = 0
                self.searchView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.searchTextField.text = ""
                self.isSearching = false
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.searchTitleTopAnchor.constant = -100
                self.searchTextFieldRightAnchor.constant = 40
                self.headerViewTopAnchor.constant = -56
                self.searchTitle.alpha = 0
                self.searchCancelButton.alpha = 1
                self.searchView.alpha = 0.4
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.isSearching = true
            })
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
