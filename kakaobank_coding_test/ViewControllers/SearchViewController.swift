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
    
    @IBOutlet var searchTitle: UILabel!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchCancelButton: UIButton!
    @IBOutlet var searchTitleTopAnchor: NSLayoutConstraint!
    @IBOutlet var headerViewTopAnchor: NSLayoutConstraint!
    @IBOutlet var searchTextFieldRightAnchor: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    var dataSource = [Model.RecentSearch]()
    
    var showTitle: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        searchTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSearch)))
        searchTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 55 {
            if !showTitle {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.showTitle = true
                })
            }
            
            scrollView.contentOffset.y = 56
            
        } else {
            if showTitle {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.showTitle = false
                })
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
        cell.update(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // search selected data's term
        let data = dataSource[indexPath.row]
        print(data.term)
    }
}

extension SearchViewController: UITextFieldDelegate {
    // 한글만 입력
    @objc func textChange() {
        guard let value = searchTextField.text else { return }
        do {
            let regEx = try NSRegularExpression(pattern: hanguelRegx, options: [])
            let num = regEx.numberOfMatches(in: value, options: [], range: NSRange(location: 0, length: value.count))
            if num == 0 {
                alert("한글만 입력 가능합니다.")
                searchTextField.text = ""
                searchTextField.becomeFirstResponder()
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let term = textField.text else { return false }
        let urlString: String = "\(searchUrl)&term=\(term)"
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 0)
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data, let _ = response, error == nil else {
                    if let error = error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async { self.alert(error.localizedDescription)}
                    }
                    return
                }
                print(Model.Results(JSON(data)))
            }.resume()
            
        }
        return true
        
    }
}

extension SearchViewController {
    @objc func handleSearch() {
        self.searchTextField.becomeFirstResponder()
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.searchTitleTopAnchor.constant = -100
                self.searchTextFieldRightAnchor.constant = 40
                self.headerViewTopAnchor.constant = -56
                self.searchTitle.alpha = 0
                self.searchCancelButton.alpha = 1
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    @IBAction func handleCancel() {
        self.view.endEditing(true)
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.searchTitleTopAnchor.constant = 20
                self.searchTextFieldRightAnchor.constant = 0
                self.headerViewTopAnchor.constant = 0
                self.searchTitle.alpha = 1
                self.searchCancelButton.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.searchTextField.text = ""
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
