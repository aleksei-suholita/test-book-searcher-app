import UIKit

class BookInfoViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    // MARK: - Variables and properties
    
    var book = Book(title: "", authors: [""], description: "", smallThumbnailURL: nil, thumbnailURL: nil)
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        descriptionLabel.isEditable = false
        
        titleLabel.text = book.title
        authorsLabel.text = book.authors.joined(separator: ", ")
        descriptionLabel.text = book.description
        if book.thumbnailURL != nil {
            coverImage.kf.setImage(with: book.thumbnailURL!)
        } else if book.smallThumbnailURL != nil {
            coverImage.kf.setImage(with: book.smallThumbnailURL!)
        } else {
            coverImage.image = UIImage(named: "NoImagePlaceholder")
        }
    }
}
