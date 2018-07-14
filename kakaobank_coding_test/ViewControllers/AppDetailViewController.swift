//
//  AppDetailViewController.swift
//  kakaobank_coding_test
//
//  Created by FURSYS on 2018. 7. 9..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppDetailViewController: UIViewController {

    var model: Model.SearchResult?
    var dataSource = [(String, String)]()
    var showTitleView: Bool = false
    
    let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let donwloadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("받기", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.4862745098, blue: 0.9647058824, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.frame = CGRect(x: 0, y: 0, width: 70, height: 20)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    @IBOutlet var headerView: AppDetailHeaderView!
    @IBOutlet var descriptionView: DescriptionView!
    @IBOutlet var thumbnailsCollectionView: UICollectionView!
    @IBOutlet var developerLabel: UILabel!
    @IBOutlet var newVersionView: NewVersionView!
    @IBOutlet var informationTableView: UITableView!
    private var indexOfCellBeforeDragging = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        setting()
        
    }
    

    func setting() {
        guard let model = model else {
            alert("데이터가 없습니다.")
            self.navigationController?.popViewController(animated: true)
            return
        }
        headerView.update(model)
        descriptionView.update(model)
        newVersionView.update(model)
        developerLabel.text = model.sellerName
        setDataSource(data: model)
        setNavigationBar(data: model)
        thumbnailsCollectionView.reloadData()
    }
    
    func setNavigationBar(data: Model.SearchResult) {
        if let url = URL(string: data.artworkUrl60) {
            logoImageView.setImage(url: url)
            logoImageView.layer.masksToBounds = true
            logoImageView.layer.cornerRadius = 5
            navigationItem.titleView = logoImageView
            navigationItem.titleView?.alpha = 0
        }
    }
    
    
    func setDataSource(data: Model.SearchResult) {
        dataSource.append(("판매자", data.sellerName))
        
        let value = (Double(data.fileSizeBytes) ?? 0) / 1024.0 / 1024.0
        let divisor = pow(10.0, 2.0)
        
        
        dataSource.append(("크기", "\(round(value * divisor) / divisor)MB"))
        dataSource.append(("카테고리", "\(data.genres.first ?? "알 수 없음")"))
        
        let iPadCount = data.supportedDevices.filter { $0.contains("iPad") }.count
        let iPhoneCount = data.supportedDevices.filter { $0.contains("iPhone") }.count
        let iPodCount = data.supportedDevices.filter { $0.contains("iPod") }.count
        var tempSupportDevice = [String]()
        if iPhoneCount > 0 { tempSupportDevice.append("iPhone") }
        if iPadCount > 0 { tempSupportDevice.append("iPad") }
        if iPodCount > 0 { tempSupportDevice.append("iPod touch") }
        
        dataSource.append(("호환성", "iOS \(data.minimumOsVersion) 버전 이상이 필요, \(tempSupportDevice.joined(separator: ", "))와(과) 호환."))
        dataSource.append(("언어", "\(data.languageCodesISO2A.joined(separator: ", "))"))
        dataSource.append(("연령", "\(data.contentAdvisoryRating)"))
        dataSource.append(("개발자 웹 사이트", "\(data.sellerUrl)"))
        dataSource.append(("개인정보 처리방침", ""))
        print(dataSource)
        
        informationTableView.reloadData()
    }
}

extension AppDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > 80 {
//            if !showTitleView {
//                navigationItem.setRightBarButton(UIBarButtonItem(customView: donwloadButton), animated: true)
//                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .allowUserInteraction, animations: {
//                    self.navigationItem.titleView?.alpha = 1å´
//                    self.navigationItem.titleView?.layoutIfNeeded()
//                })
//                showTitleView = true
//            }
//        } else {
//            if showTitleView {
//                navigationItem.setRightBarButton(nil, animated: true)
//                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .allowUserInteraction, animations: {
//                    self.navigationItem.titleView?.alpha = 0
//                    self.navigationItem.titleView?.layoutIfNeeded()
//                })
//                showTitleView = false
//            }
//        }
    }
}

extension AppDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as! InformationCell
        cell.update(dataSource[indexPath.row])
        if dataSource[indexPath.row].0 == "개발자 웹 사이트" || dataSource[indexPath.row].0 == "개인정보 처리방침"  {
            cell.categoryLabel.textColor = #colorLiteral(red: 0.1725490196, green: 0.4862745098, blue: 0.9647058824, alpha: 1)
            cell.informationLabel.textColor = #colorLiteral(red: 0.1725490196, green: 0.4862745098, blue: 0.9647058824, alpha: 1)
            cell.informationLabel.text = "✿"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource[indexPath.row].0 == "개발자 웹 사이트" {
            let url = dataSource[indexPath.row].1
            if let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

extension AppDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.screenshotUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailsCell", for: indexPath) as! ThumbnailsCell
        if let model = model {
            cell.update(model.screenshotUrls[indexPath.row])
        }
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let index = indexOfMajorCell()
        if let model = model {
        let dataSourceCount = model.screenshotUrls.count
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = index == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
            if didUseSwipeToSkipCell {
                let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
                let toValue = 240 * CGFloat(snapToIndex)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    scrollView.layoutIfNeeded()
                }, completion: nil)
            } else {
                thumbnailsCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
                if index < dataSourceCount - 1 {
                    scrollView.contentOffset.x -= 10
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    private func indexOfMajorCell() -> Int {
        let proportionalOffset = thumbnailsCollectionView.contentOffset.x / 240
        return Int(round(proportionalOffset))
    }
}

