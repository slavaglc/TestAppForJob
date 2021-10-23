

import Foundation
import UIKit


final class ImageDataManager {
    static let shared = ImageDataManager()
    
    private init() {}
    
    public func fetchRandomImage(completion: @escaping (_ imageProperties: ImageModel)->()) {
        
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random" ) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _ ) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let imageProperties = try decoder.decode(ImageModel.self, from: data)
                completion(imageProperties)
            } catch let error {
                print("Error with json serialization:", error)
            }
            
        }.resume()
    }
}


