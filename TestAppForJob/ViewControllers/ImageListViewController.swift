//
//  ViewController.swift
//  TestAppForJob
//
//  Created by Вячеслав Макаров on 23.10.2021.
//

import UIKit

@available(iOS 13.0, *)
final class ImageListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    private let imageDataManager = ImageDataManager.shared
    private let maxCount = 300
    private var imageLinks = [String]()
    private var directionIsDown = false
    private var contentOffset = CGPoint.zero
    private var currentOffset = CGPoint.zero
    private var cvCounter = 0
    private var fetchingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        
        swipeUp.delegate = self
        swipeDown.delegate = self
     
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.generateImageURLs(count: 100)
        }
        
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        cvCounter
        imageLinks.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Item Number:", indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = nil
        
            let urlString = imageLinks[indexPath.item]
            guard let imageURL = URL(string: urlString) else {
                print("emtpy cell...")
                return cell}
            
            imageDataManager.getCachedImage(from: imageURL) { [unowned self] image in
                DispatchQueue.main.async {
                guard let image = image else {
                    downloadImage(for: cell, with: urlString)
                    return
                }
//                print("fetching from cache...")
                    cell.imageView.image = image
                }
            }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width / 3.2 , height: UIScreen.main.bounds.width / 3.2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 3, bottom: 10, right: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentOffset.x = scrollView.contentOffset.x
        contentOffset.x = scrollView.contentSize.width - scrollView.frame.width
//        print("currentOffset:", currentOffset.y, "contentSize:", contentOffset.y)
        
        if currentOffset.x > contentOffset.x {
            if !fetchingMore {
                fetchingMore = true
                print("fetchingMore...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                    generateImageURLs(count: 20)
                    print("+20")
                }
            }
        }
    }
    
    
    
    
    
    private func generateImageURLs(count: Int) {
        let groupForAddingImage = DispatchGroup()
        let groupForFinishingLoad = DispatchGroup()
        
        groupForFinishingLoad.enter()
        for iteration in 0...count {
            
            imageDataManager.fetchRandomImageURL { [unowned self] url in
                groupForAddingImage.enter()
                imageLinks.append(url)
                
                groupForAddingImage.leave()
                
                if iteration == count {
                    groupForFinishingLoad.leave()
                }
            }
            
    
        }
        
        groupForFinishingLoad.notify(queue: .global(qos: .background)) {
            self.fetchingMore = false
        }
        
        groupForAddingImage.notify(queue: .main) {
            self.collectionView.reloadData()
        }
        
    }
    
    private func downloadImage(for cell: PhotoCollectionViewCell, with url: String) {
        imageDataManager.downloadImageData(url: url) { imageData, response in
//            print("download...")
            DispatchQueue.main.async {
            cell.imageView.image = UIImage(data: imageData)
            cell.moveIn()
            self.imageDataManager.saveImageDataToCache(data: imageData, response: response)
            }
        }
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollEnding")
    }
}

@available(iOS 13.0, *)
extension ImageListViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            return true
        }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
           if let swipeGesture = gesture as? UISwipeGestureRecognizer {
               switch swipeGesture.direction {
               case UISwipeGestureRecognizer.Direction.down:
                   print("swipeDown")
                   directionIsDown = true
               case UISwipeGestureRecognizer.Direction.up:
                   directionIsDown = false
                   print("swipeUp")
               default:
                   break
               }
           }
       }
}




