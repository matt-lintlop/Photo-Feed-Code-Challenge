//
//  PhotoFeedItem.swift
//  PhotoFeed
//
//  Created by Matt Lintlop on 10/26/21.
//

import Foundation

class PhotoFeedItem {
    var imagePath: String?
    var title: String?
    var commentNumber: Int?
    var score: Int?
    var imageWidth: Int?
    var imageHeight: Int?
    var thumbnailWidth: Int?
    var thumbnailHeight: Int?
    var imageJSON: [String: Any]?
    var aspectRatio: Double? {
        get {
            guard let thumbnailWidth = self.thumbnailWidth,
                  let thumbnailHeight = self.thumbnailHeight else {
                      return nil
            }
            return Double(thumbnailWidth) / Double(thumbnailHeight)
        }
    }
    
    init?(photoFeedItemJSON json: [String:Any]) {
        
        // get the photo feed item data json
        guard let jsonData = json["data"] as? [String:Any] else {
            return nil
        }
        
        // set the image psth to the Thumbnail
        guard let imagePath = jsonData["thumbnail"] as? String else {
            print("Error getting thumbnail")
            return
        }
        self.imagePath = imagePath
        
        // set the Thumbnail Width & Thumbnail Height
        guard let thumbnailWidth = jsonData["thumbnail_width"] as? Int,
              let thumbnailHeight = jsonData["thumbnail_height"] as? Int else {
                return
        }
        self.thumbnailWidth = thumbnailWidth
        self.thumbnailHeight = thumbnailHeight
        
        // set the Title
        guard let title = jsonData["title"] as? String else {
            return nil
        }
 
        self.title = title

        // set the Comment Number
        guard let commentNumber = jsonData["num_comments"] as? Int else {
            return nil
        }
        self.commentNumber = commentNumber
        
        // Set the Score
        guard let score = jsonData["score"] as? Int else {
            return nil
        }
        self.score = score
    }

}
