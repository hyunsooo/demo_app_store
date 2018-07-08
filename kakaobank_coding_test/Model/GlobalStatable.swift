//
//  GlobalStatable.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 8..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import Foundation

protocol GlobalStatable: Equatable {
    associatedtype WritableType
    var writeValue: WritableType { get }
    static func readValue(value: WritableType?) -> Self
}

extension String: GlobalStatable {
    var writeValue: String {
        return self
    }
    static func readValue(value: String?) -> String {
        return value ?? ""
    }
}

extension Bool: GlobalStatable {
    var writeValue: Bool {
        return self
    }
    static func readValue(value: Bool?) -> Bool {
        return value ?? true
    }
}

struct RecentSearchTerms {
    var searchs: [String]
    func add(search: String) -> RecentSearchTerms {
        let newSearchs = Set<String>(searchs + [search]).map{$0}
        return RecentSearchTerms(searchs: newSearchs)
    }
}

extension RecentSearchTerms: GlobalStatable {
    
    typealias WritableType = [String]
    
    static func ==(lhs: RecentSearchTerms, rhs: RecentSearchTerms) -> Bool {
        guard lhs.searchs.count == rhs.searchs.count else { return false }
        return lhs.searchs.elementsEqual(rhs.searchs)
        
    }
    var writeValue: [String] {
        return self.searchs.map {
            $0.writeValue
        }
    }
    
    static func readValue(value: [String]?) -> RecentSearchTerms {
        return RecentSearchTerms(searchs: value ?? [] )
    }
}
