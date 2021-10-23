

import Foundation
import UIKit


final class ImageDataManager {
    static let shared = ImageDataManager()
    
    private init() {}
    
//    public func fetchRandomData(completion: @escaping (_ imageProperties: ImageModel)->()) {
//
//        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random" ) else { return }
//        URLSession.shared.dataTask(with: url) { (data, _, _ ) in
//
//            guard let data = data else { return }
//
//            do {
//                let decoder = JSONDecoder()
//                let imageProperties = try decoder.decode(ImageModel.self, from: data)
//                completion(imageProperties)
//            } catch let error {
//                print("Error with json serialization:", error)
//            }
//
//        }.resume()
//    }
    
    public func fetchRandomImageData(completion: @escaping (_ imageData: Data)->()) {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random" ) else { return }
        URLSession.shared.dataTask(with: url) { [unowned self] (data, _, _) in
            
            guard let data = data else { return print("failure")}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = json as? [String: String] else { return }
                guard let url = jsonDict["message"] else { return }
                
                    self.downloadImageData(url: url) { imageData in
                        
                            completion(imageData)
                        
                    }
                
                
                
            } catch let error {
                print(error)
            }
            completion(data)
        }.resume()
    }
    
    private func downloadImageData(url: String, completion: @escaping (_ imageData: Data)->()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
    
}


