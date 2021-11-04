import UIKit

class ImageCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.contentView.frame
    }
        
    private func initialize() {
        self.addSubview(self.imageView)
        self.imageView.contentMode = .scaleToFill
        self.backgroundColor = .yellow
        self.backgroundView?.backgroundColor = .yellow
    }
    
    private func downloadImage(with url: URL) {
        ImageDataManager.shared.downloadImageData(url: url.absoluteString) { imageData, response in
            print("downloading...")
            guard let image = UIImage(data: imageData) else { return }
            ImageDataManager.shared.saveImageDataToCache(data: imageData, response: response)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    public func setImage(by urlString: String) {
        guard let url = URL.init(string: urlString) else {
            print("некорректный url")
            return }
        ImageDataManager.shared.getCachedImage(from: url) { image in
            guard let image = image else {
                self.downloadImage(with: url)
                return
            }
            print("fetching from cache...")
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
    }
    
    
    func moveIn() {
        transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        alpha = 0.0
        isHidden = false
        
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.alpha = 1.0
        }
    }
    
}

