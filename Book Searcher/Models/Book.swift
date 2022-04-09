import UIKit

class Book {
    
    // MARK: - Constants
    
    let title: String
    let authors: [String]
    let description: String
    let smallThumbnailURL: URL?
    let thumbnailURL: URL?
    
    // MARK: - Initialization
    
    init(title: String, authors: [String], description: String, smallThumbnailURL: URL?, thumbnailURL: URL?) {
        self.title = title
        self.authors = authors
        self.description = description
        self.smallThumbnailURL = smallThumbnailURL
        self.thumbnailURL = thumbnailURL
    }
}
