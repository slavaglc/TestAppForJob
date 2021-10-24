

import Foundation
import UIKit


final class ImageDataManager {
    static let shared = ImageDataManager()
    
    private init() {}
    
    public func fetchRandomImageURL(completion: @escaping (_ url: String)->()) {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random" ) else { return }
        URLSession.shared.dataTask(with: url) { [unowned self] (data, _, _) in
            
            guard let data = data else { return print("failure")}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = json as? [String: String] else { return }
                guard let url = jsonDict["message"] else { return }
                
                    completion(url)
                
//                    self.downloadImageData(url: url) { imageData in
//                            completion(imageData, url)
//                    }
                
            } catch let error {
                print(error)
            }
           //completion(data, url)
        }.resume()
    }
    
    func downloadImageData(url: String, completion: @escaping (_ imageData: Data)->()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
    
}


