//
//  FlickerDBConstant.swift
//  Akkar
//
//  Created by Mahmoud Zakaria on 12/06/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import Foundation

extension FlickerDBClient {
    
    // MARK: - Constants
    
    // https://api.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=bc339677e0b0fd73a6f71d079529e81c&user_id=138006921%40N03&format=json&nojsoncallback=1
    
    // https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=bc339677e0b0fd73a6f71d079529e81c&photoset_id=72157664167499757&user_id=138006921%40N03&extras=url_m&format=json&nojsoncallback=1
    
    struct Constants {
        
        // MARK: Flickr
        struct Flickr {
            static let APIScheme = "https"
            static let APIHost = "api.flickr.com"
            static let APIPath = "/services/rest"
        }
        
        // MARK: Flickr Parameter Keys
        struct FlickrParameterKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let UserID = "user_id"
            static let PhotoSetID = "photoset_id"
            static let PhotoID = "photo_id"
            static let Format = "format"
            static let NoJSONCallback = "nojsoncallback"
            static let Extras = "extras"
        }
        
        // MARK: Flickr Parameter Values
        struct FlickrParameterValues {
            static let SearchMethod_getList = "flickr.photosets.getList"
            static let SearchMethod_getPhotos = "flickr.photosets.getPhotos"
            static let SearchMethod_getLocation = "flickr.photos.geo.getLocation"
            static let APIKey = "afe4e887ba4a6d7ca0a29b193f87c93b"
            static let UserID = "138006921@N03"
            static let ResponseFormat = "json"
            static let DisableJSONCallback = "1"
            static let MediumURL = "url_m"
        }
        
        // MARK: Flickr Response Keys
        struct FlickrResponseKeys {
            static let Status = "stat"
            static let PhotoSets = "photosets"
            static let PhotoSet = "photoset"
            static let Photo = "photo"
            static let MediumURL = "url_m"
            static let Page = "page"
            static let Pages = "pages"
            static let Total = "total"
            static let PhotoSetID = "id"
            static let PhotoID = "id"
            static let Location = "location"
            static let Latitude = "latitude"
            static let Longitude = "longitude"
            static let PhotoSetTitle = "title"
            static let PhotoSetContent = "_content"
        }
        
        // MARK: Flickr Response Values
        struct FlickrResponseValues {
            static let OKStatus = "ok"
        }
    }
}
