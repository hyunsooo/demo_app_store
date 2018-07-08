//
//  GlobalState.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 8..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import Foundation

final class GlobalState {
    static let instance: GlobalState = GlobalState()
    
    enum Constants: String {
        case recentSearch
    }
    
    var recentSearch: [String] {
        get {
            let searchs = UserDefaults.standard.array(forKey: Constants.recentSearch.rawValue) as? [String] ?? []
            return searchs
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.recentSearch.rawValue)
        }
    }
}
