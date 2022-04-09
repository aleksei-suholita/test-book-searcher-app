import Foundation
import UIKit

class NetworkService {
    
    // MARK: - Constants & Singleton
    
    static let instance = NetworkService()
    let defaultSession = URLSession(configuration: .default)
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Variables And Properties
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var books: [Book] = []
    
    // MARK: - Type Alias
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Book]?, String) -> Void
    
    // MARK: - Internal Methods
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://www.googleapis.com/books/v1/volumes") {
            urlComponents.query = "q=\(searchTerm)&projection=lite"
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    self.updateSearchResults(data)
                    DispatchQueue.main.async {
                        completion(self.books, self.errorMessage ?? "")
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    // MARK: - Private Methods
    
    private func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        books.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["items"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        
        for bookDictionary in array {
            if let bookDictionary = bookDictionary as? JSONDictionary,
               let volumeInfoDictionary = bookDictionary["volumeInfo"] as? JSONDictionary,
               let title = volumeInfoDictionary["title"] as? String,
               let authors = volumeInfoDictionary["authors"] as? [String],
               let description = volumeInfoDictionary["description"] as? String,
               let imageLinksDictionary = volumeInfoDictionary["imageLinks"] as? JSONDictionary {
                
                let thumbnailLink = URL(string: imageLinksDictionary["thumbnail"] as? String ?? "")
                let smallThumbnailLink = URL(string: imageLinksDictionary["smallThumbnail"] as? String ?? "")
                
                books.append(Book(title: title, authors: authors, description: description, smallThumbnailURL: smallThumbnailLink, thumbnailURL: thumbnailLink))
            } else {
                errorMessage += "Problem parsing bookDictionary\n"
            }
        }
    }
}
