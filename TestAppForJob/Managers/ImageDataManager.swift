

import Foundation
import UIKit


final class ImageDataManager {
    static let shared = ImageDataManager()
    let cache = NSCache<NSNumber, UIImage>()
    let maxImagesForCache = 300
    
    private init() {
        cache.countLimit = maxImagesForCache
        cache.totalCostLimit = 150 * 1024 * 1024
    }
    
    public func fetchRandomImageURL(completion: @escaping (_ url: String)->()) {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random" ) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            
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
        }.resume()
    }
    
    func downloadImageData(url: String, completion: @escaping (_ imageData: Data,_ response: URLResponse)->()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data, let response = response else { return }
            completion(data, response)
        }.resume()
    }
    
    func saveImageDataToCache(data: Data, response: URLResponse) {
            guard let urlResponse = response.url else { return }
            let request = URLRequest(url: urlResponse)
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            print("Saved to cache")
        
    }
    
    func saveImageDataToCache(with image: UIImage, forKey key: Int) {
        let numberKey = NSNumber(value: key)
        cache.setObject(image, forKey: numberKey)
    }
    
    func getCachedImage(from url: URL, completion: @escaping (UIImage?)->() ) {
            let request = URLRequest(url: url)
        
            if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
                completion(UIImage(data: cachedResponse.data))
            } else {
                completion(nil)
            }
        
        
    }
    
    func getCachedImage(from key: Int, completion: @escaping (UIImage?)->()) {
        let numberKey = NSNumber(value: key)
        if let cachedImage = cache.object(forKey: numberKey) {
            completion(cachedImage)
        }
        else {
            completion(nil)
        }
    }
    
}


