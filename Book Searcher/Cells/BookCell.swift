import UIKit
import Kingfisher

class BookCell: UITableViewCell {
    
    // MARK: - Class Constants
    
    static let identifier = "BookCell"

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    
    // MARK: - Internal Methods
    
    func configure(book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.authors.joined(separator: ", ")
        if book.thumbnailURL != nil {
            thumbnailImageView.kf.setImage(with: book.thumbnailURL!)
        } else if book.smallThumbnailURL != nil {
            thumbnailImageView.kf.setImage(with: book.smallThumbnailURL!)
        } else {
            thumbnailImageView.image = UIImage(named: "NoImagePlaceholder")
        }
    }
}
