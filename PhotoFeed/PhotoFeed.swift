//
//  PhotoFeed.swift
//  PhotoFeed
//
//  Created by Matt Lintlop on 10/26/21.
//

import Foundation

class PhotoFeed {
    
    private var photoFeedItems: [PhotoFeedItem]?            // all of photo feed items owned by this photo feed
    
    var afterPhotoFeedURLTag: String?                       // the next after photo feed url tag
    
    var photoFeedItemCount: Int {
        get {
            if photoFeedItems != nil {
                return photoFeedItems!.count
            }
            else {
                return 0
            }
        }
    }
    
    init?(withData data: Data) {
        photoFeedItems = []
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let jsonData = json["data"] as? [String: Any],
            let feedItemsJSON = jsonData["children"] as? [[String: Any]] else {
            print("Error decoding JSON from data in NetworkServices")
            return nil
        }

        // for fetching the next photo feed items
        if let afterPhotoItemTag = jsonData["after"] as? String {
            self.afterPhotoFeedURLTag = afterPhotoItemTag
        }
        
        for feedItemJSON in feedItemsJSON {
            if let photoFeedItem = PhotoFeedItem(photoFeedItemJSON: feedItemJSON) {
                photoFeedItems!.append(photoFeedItem)
            }
        }
        guard photoFeedItems!.count > 0 else {
            return nil
        }
    }

    func photoFeedItem(atIndex index: Int) -> PhotoFeedItem? {
        guard let photoFeedItems = self.photoFeedItems else {
            return nil
        }
        guard index > 0 && index < photoFeedItems.count else {
            return nil
        }
        return photoFeedItems[index]
    }
    
}
