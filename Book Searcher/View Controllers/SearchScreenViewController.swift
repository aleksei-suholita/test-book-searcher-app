import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables and properties
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
      var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
      return recognizer
    }()
    
    var searchResults: [Book] = []
    
    // MARK: - Internal Methods
    
    @objc func dismissKeyboard() {
      searchBar.resignFirstResponder()
    }
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        NetworkService.instance.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            if let results = results {
              self?.searchResults = results
              self?.tableView.reloadData()
              self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            }

            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      view.removeGestureRecognizer(tapRecognizer)
    }
}


// MARK: - Table View Data Source

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier, for: indexPath) as! BookCell
        cell.configure(book: searchResults[indexPath.row])
        return cell
    }
}

// MARK: - Table View Delegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookInfoViewController = storyboard?.instantiateViewController(withIdentifier: "BookInfoViewController") as? BookInfoViewController {
            bookInfoViewController.book = searchResults[indexPath.row]
            navigationController?.pushViewController(bookInfoViewController, animated: true)
        }
    }
}
