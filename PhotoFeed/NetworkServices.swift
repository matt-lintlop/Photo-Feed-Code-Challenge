//
//  NetworkServices.swift
//  PhotoFeed
//
//  Created by Matt Lintlop on 10/26/21.
//

import Foundation
import UIKit

enum NetworkServicesError: Error {
    case errorLoadingJSON
    case errorParsingJSON
    case invalidURLError
}

class NetworkServices  {
    
    static let shared = NetworkServices()
    
    // The current photo feed after url tag
    var afterPhotoFeedURLTag: String?

    var photoFeeds: [PhotoFeed]?
    
    let group = DispatchGroup()
    
    private init() {
        photoFeeds = []
    }
    
    func setAfterPhotoFeedURLTag(afterPhotoFeedURLTag: String?) {
        self.afterPhotoFeedURLTag = afterPhotoFeedURLTag
    }
    
    func photoFeedsURL(afterPhotoFeedURLTag : String?) -> URL? {
        var afterPhotoFeedURLTag = afterPhotoFeedURLTag
        
        if afterPhotoFeedURLTag == nil {
            afterPhotoFeedURLTag = self.afterPhotoFeedURLTag
        }
        
        var path: String = ""
        if let afterPhotoFeedURLTag = afterPhotoFeedURLTag {
            path = "http://www.reddit.com/.json?after=\(afterPhotoFeedURLTag)"
        }
        else {
            path = "http://www.reddit.com/.json"
        }
            
        
        print("*** Photo Feed URL: \(path)")
        
        return URL(string: path)
    }

    // MARK: Fetching

    func fetchNextPhotoFeed(completion: @escaping (PhotoFeed?, NetworkServicesError?) -> Void) {
        
        return self.fetchPhotoFeed(afterPhotoFeedURLTag: self.afterPhotoFeedURLTag, completion: completion)
    }
  
    func fetchPhotoFeed(afterPhotoFeedURLTag photoFeedURLTag: String?,
                        completion: @escaping (PhotoFeed?, NetworkServicesError?) -> Void) {
            
        group.wait()
        group.enter()
        
        guard let photoFeedURL = photoFeedsURL(afterPhotoFeedURLTag: photoFeedURLTag) else {
            completion(nil, NetworkServicesError.invalidURLError)
            group.leave()
            return
        }
         
        URLSession.shared.dataTask(with: photoFeedURL) { data, response, error in
            if let data = data, let photoFeed = PhotoFeed(withData: data) {
                completion(photoFeed, nil)
                self.group.leave()
            }
            else {
                completion(nil, .errorLoadingJSON)
                self.group.leave()
            }
        }.resume()
    }
}
