//
//  ViewController.swift
//  TestAppForJob
//
//  Created by Вячеслав Макаров on 23.10.2021.
//

import UIKit

final class ImageListViewController: UICollectionViewController {
    let imageDataManager = ImageDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageDataManager.fetchRandomData { imageProperties in
//            print(imageProperties)
//        }
        imageDataManager.fetchRandomImageData { imageData in
             print("data:", imageData)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        imageDataManager.fetchRandomImageData { imageData in
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                let imageView = UIImageView(image: image)
                cell.contentView.addSubview(imageView)
            }
    
        }
    
        return cell
    }

    
}

