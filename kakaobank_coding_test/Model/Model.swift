//
//  Model.swift
//  kakaobank_coding_test
//
//  Created by hyunsu han on 2018. 7. 7..
//  Copyright © 2018년 hyunsoo. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Model { }

extension Model {
    struct RecentSearch {
        let term: String
    }
    
    struct Results {
        let results: [SearchResult]
        let resultCount: Int
        
        init(_ json: JSON) {
            results = json["results"].arrayValue.map { SearchResult($0) }
            resultCount = json["resultCount"].intValue
        }
    }
    
    
    struct SearchResult {
        let features: [String]
        let kind: String
        let isGameCenterEnabled: Bool
        let trackId: Int
        let contentAdvisoryRating: String
        let currentVersionReleaseDate: String
        let bundleId: String
        let artworkUrl60: String
        let averageUserRatingForCurrentVersion: Int
        let trackViewUrl: String
        let primaryGenreId: Int
        let artworkUrl100: String
        let releaseNotes: String
        let currency: String
        let userRatingCountForCurrentVersion: Int
        let wrapperType: String
        let userRatingCount: Int
        let minimumOsVersion: String
        let fileSizeBytes: String
        let artworkUrl512: String
        let ipadScreenshotUrls: [String]
        let artistName: String
        let isVppDeviceBasedLicensingEnabled: Bool
        let sellerUrl: String
        let trackCensoredName: String
        let averageUserRating: Int
        let appletvScreenshotUrls: [String]
        let genres: [String]
        let releaseDate: String
        let description: String
        let primaryGenreName: String
        let languageCodesISO2A: [String]
        let artistId: Int
        let genreIds: [String]
        let price: Int
        let trackName: String
        let screenshotUrls: [String]
        let sellerName: String
        let advisories: [String]
        let supportedDevices: [String]
        let formattedPrice: String
        let trackContentRating: String
        let version: String
        let artistViewUrl: String
        
        init(_ json: JSON) {
            features = json["features"].arrayValue.map { $0.stringValue }
            kind = json["kind"].stringValue
            isGameCenterEnabled = json["isGameCenterEnabled"].boolValue
            trackId = json["trackId"].intValue
            contentAdvisoryRating = json["contentAdvisoryRating"].stringValue
            currentVersionReleaseDate = json["currentVersionReleaseDate"].stringValue
            bundleId = json["bundleId"].stringValue
            artworkUrl60 = json["artworkUrl60"].stringValue
            averageUserRatingForCurrentVersion = json["averageUserRatingForCurrentVersion"].intValue
            trackViewUrl = json["trackViewUrl"].stringValue
            primaryGenreId = json["primaryGenreId"].intValue
            artworkUrl100 = json["artworkUrl100"].stringValue
            releaseNotes = json["releaseNotes"].stringValue
            currency = json["currency"].stringValue
            userRatingCountForCurrentVersion = json["userRatingCountForCurrentVersion"].intValue
            wrapperType = json["wrapperType"].stringValue
            userRatingCount = json["userRatingCount"].intValue
            minimumOsVersion = json["minimumOsVersion"].stringValue
            fileSizeBytes = json["fileSizeBytes"].stringValue
            artworkUrl512 = json["artworkUrl512"].stringValue
            ipadScreenshotUrls = json["ipadScreenshotUrls"].arrayValue.map { $0.stringValue }
            artistName = json["artistName"].stringValue
            isVppDeviceBasedLicensingEnabled = json["isVppDeviceBasedLicensingEnabled"].boolValue
            sellerUrl = json["sellerUrl"].stringValue
            trackCensoredName = json["trackCensoredName"].stringValue
            averageUserRating = json["averageUserRating"].intValue
            appletvScreenshotUrls = json["appletvScreenshotUrls"].arrayValue.map { $0.stringValue }
            genres = json["genres"].arrayValue.map { $0.stringValue }
            releaseDate = json["releaseDate"].stringValue
            description = json["description"].stringValue
            primaryGenreName = json["primaryGenreName"].stringValue
            languageCodesISO2A  = json["languageCodesISO2A"].arrayValue.map { $0.stringValue }
            artistId = json["artistId"].intValue
            genreIds = json["genreIds"].arrayValue.map { $0.stringValue }
            price = json["price"].intValue
            trackName = json["trackName"].stringValue
            screenshotUrls = json["screenshotUrls"].arrayValue.map { $0.stringValue }
            sellerName = json["sellerName"].stringValue
            advisories = json["advisories"].arrayValue.map { $0.stringValue }
            supportedDevices = json["supportedDevices"].arrayValue.map { $0.stringValue }
            formattedPrice = json["formattedPrice"].stringValue
            trackContentRating = json["trackContentRating"].stringValue
            version = json["version"].stringValue
            artistViewUrl = json["artistViewUrl"].stringValue
        }
    }
}
