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
    private var cvCounter = 1
    
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
        
        //generateImageURL()
        //generateImageURL()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for _ in 1...3 {
        generateImageURL()
        }
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        imageDataManager.downloadImageData(url: imageLinks[indexPath.item]) { imageData in
            guard let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                let imageView = UIImageView(image: image)
                let frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: cell.contentView.frame.height)
                imageView.frame = frame
                cell.addSubview(imageView)
//                if self.imageLinks.count < self.maxCount{
//                    self.generateImageURL()
//                }
                
            }
            print(self.imageLinks.count)
        }
        
        
        
//        let image = images[indexPath.item]
//        let imageView = UIImageView(image: image)
//        let frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: cell.contentView.frame.height)
//        imageView.frame = frame
        
//        imageDataManager.fetchRandomImageData { imageData in
//            DispatchQueue.main.async { [self] in
//            guard let image = UIImage(data: imageData) else{ return }
//            let imageView = UIImageView(image: image)
//            cell.contentView.backgroundColor = .blue
//            cell.contentView.addSubview(imageView)
//                cvCounter += 1
//            }
//        }
        
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width / 3 , height: UIScreen.main.bounds.width / 3 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
        contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
//        print("currentOffset:", currentOffset.y, "contentSize:", contentOffset.y)
    }
    
    
    
    private func generateImageURL() {
        
        imageDataManager.fetchRandomImageURL { [unowned self] url in
           // guard let image = UIImage(data: imageData) else { return }
            imageLinks.append(url)
//            DispatchQueue.main.async {
//                collectionView.reloadData()
//            }
            
        }
        
        collectionView.reloadData()
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




