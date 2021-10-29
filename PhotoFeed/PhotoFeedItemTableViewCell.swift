//
//  PhotoFeedItemTableViewCell.swift
//  PhotoFeed
//
//  Created by Matt Lintlop on 10/26/21.
//

import UIKit

class PhotoFeedItemTableViewCell: UITableViewCell {

    @IBOutlet weak var commentNumber: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    var photoFeedItem: PhotoFeedItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPhotoFeedItem(_ photoFeedItem: PhotoFeedItem) {
        
        self.photoFeedItem = photoFeedItem
        
        DispatchQueue.main.async {
            if let title = photoFeedItem.title {
                self.title.text = title
            }
            if let score = photoFeedItem.score {
                self.score.text = "\(score)"
            }
            if let commentNumber = photoFeedItem.commentNumber {
                self.commentNumber.text = "\(commentNumber)"
            }
        }
        
        if let imagePath = photoFeedItem.imagePath {
            self.loadImage(withPath: imagePath) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        self.poster.image = image
                        self.poster.setNeedsDisplay()
                    }
                }
             }
        }
    }
    
    // MARK: Image
    
    func loadImage(withPath imagePath: String, completion: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: imagePath),
                  let imageData = try? Data(contentsOf: imageURL)  else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: imageData) {
                    completion(image)
                }
                else {
                   completion(nil)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        self.poster.image = nil
        self.title.text = nil
        self.score.text = nil
        self.commentNumber.text = nil
    }

}
