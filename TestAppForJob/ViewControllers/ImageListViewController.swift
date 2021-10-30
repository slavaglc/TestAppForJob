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
//    private var images: [UIImage?] = []
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
        generateImageURLs(count: 100)
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        cvCounter
        imageLinks.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        contentOffset = collectionView.contentOffset
       
        
//        print(directionIsDown)
//        print("currentOffset:", currentOffset.y, "contentSize:", contentOffset.y)
//        if currentOffset.y > (contentOffset.y - 200) && !directionIsDown {
//            print("generating...")
//            generateImage()
//        }
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! PhotoCollectionViewCell
        
        DispatchQueue.global().async { [unowned self] in
            
            let urlString = imageLinks[indexPath.item]
            //print(urlString, cvCounter)
            guard let imageUrl = URL (string: urlString) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            guard let image = UIImage(data: imageData) else { return }
            
            
            DispatchQueue.main.async {
                let frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: cell.contentView.frame.height)
                let imageView = UIImageView(image: image)
                cell.imageView.image = image
            }
                
            }
                
            
        
                
            //print(self.imageLinks.count)
  
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
        currentOffset.y = scrollView.contentOffset.y
        contentOffset.y = scrollView.contentSize.height - scrollView.frame.height
        print("currentOffset:", currentOffset.y, "contentSize:", contentOffset.y)
        
        if currentOffset.y > contentOffset.y {
            if !fetchingMore {
                print("fetchingMore...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
                    generateImageURLs(count: 12)
                    print("+12")
                }
            }
        }
        
        
    }
    
    
    
    
    
    private func generateImageURLs(count: Int) {
        fetchingMore = true
        let group = DispatchGroup()
        let group2 = DispatchGroup()
        
        for iteration in 0...count {
            
            group.enter()
            group2.enter()
            
            imageDataManager.fetchRandomImageURL { [unowned self] url in
                imageLinks.append(url)
                
                if iteration == count {
                    group2.leave()
                }
                
                group.leave()
                
            }
            
    
        }
        
        group2.notify(queue: .main) {
            print("group 2 started")
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
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




