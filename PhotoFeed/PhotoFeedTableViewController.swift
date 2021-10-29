//
//  PhotoFeedTableViewController.swift
//  PhotoFeed
//
//  Created by Matt Lintlop on 10/26/21.
//

import UIKit

class PhotoFeedTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var photoFeeds = [PhotoFeed]()
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photo Feed"

        self.fetchNextPhotoFeed()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }

    // MARK: - Photo Feed

    func fetchNextPhotoFeed() {
               
        group.wait()
        group.enter()
        
        NetworkServices.shared.fetchNextPhotoFeed { photoFeed, error in
            self.group.leave()

            guard error == nil else {
                return
            }
            if let photoFeed = photoFeed {
                NetworkServices.shared.setAfterPhotoFeedURLTag(afterPhotoFeedURLTag: photoFeed.afterPhotoFeedURLTag
                )
                self.photoFeeds.append(photoFeed)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("Success! Fetched \(photoFeed.photoFeedItemCount) photo feed items")
            }
        }
    }
    
    // MARK: - Photo feed items

    func photoFeedItemCount() -> Int {
        let photoFeedItemCount = photoFeeds.reduce(0, { partialResult, photoFeed in
            return partialResult + photoFeed.photoFeedItemCount
        })
        return photoFeedItemCount
    }
    
    func photoFeedItem(atIndex fetchPhotoFeedIndex: Int) -> PhotoFeedItem? {
        
        var photoFeedItem: PhotoFeedItem?
        var feedStartIndex = 0
        
        for photoFeed in photoFeeds {
            let photoFeedItemCount = photoFeed.photoFeedItemCount
            if (fetchPhotoFeedIndex >= feedStartIndex) &&
                (fetchPhotoFeedIndex < (feedStartIndex + photoFeedItemCount)) {
                photoFeedItem = photoFeed.photoFeedItem(atIndex: fetchPhotoFeedIndex - feedStartIndex)
            }
            else {
                feedStartIndex += photoFeedItemCount
            }
        }
        return photoFeedItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Photo Feed (\(photoFeedItemCount()))"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoFeedItemCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let photoFeedItem = photoFeedItem(atIndex: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoFeedItemCell",
                                                       for: indexPath) as? PhotoFeedItemTableViewCell else {
            return UITableViewCell()
        }
        cell.prepareForReuse()
        
        cell.setPhotoFeedItem(photoFeedItem)
        
        let photoFeedItemCount = photoFeedItemCount()
        
        if  indexPath.row >= (photoFeedItemCount - 5) {
            fetchNextPhotoFeed()
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
