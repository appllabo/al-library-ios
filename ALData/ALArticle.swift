import SwiftyJSON
import AlamofireImage

public class ALArticle: ALData {
    public var isRead = false
	public var imageThumbnail: UIImage?
	public var imageWebsite: UIImage?
    public var imageTag: UIImage?
	
	public var title: String? {
		return nil
	}
	
	public var website: String? {
		return nil
	}
	
	public var stringTags: String? {
		return nil
	}
	
    public func loadThumbnailImage(filter: ImageFilter, block: @escaping (UIImage) -> Void) {
        if let url = self.urlImageThumbnail {
            let urlRequest = URLRequest(url: url)
            
            ImageDownloader.default.download(urlRequest, filter: filter) {response in
                if let image = response.result.value {
					self.imageThumbnail = image
					
                    block(image)
                }
            }
        }
    }
    
    public func loadWebsiteImage(filter: ImageFilter, block: @escaping (UIImage) -> Void) {
        if let url = self.urlImageWebsite {
            let urlRequest = URLRequest(url: url)
            
            ImageDownloader.default.download(urlRequest, filter: filter) {response in
                if let image = response.result.value {
					self.imageWebsite = image
					
                    block(image)
                }
            }
        }
    }
    
    public func loadTagImage(filter: CompositeImageFilter, block: @escaping (UIImage) -> Void) {
        if let url = self.urlImageTag {
            let urlRequest = URLRequest(url: url)
            
            ImageDownloader.default.download(urlRequest, filter: filter) {response in
                if let image = response.result.value {
                    self.imageTag = image
                    
                    block(image)
                }
            }
        }
    }
    
    public var date: String? {
        return nil
    }
    
	public var url: URL? {
		return nil
	}
	
	public var urlImageThumbnail: URL? {
		return nil
	}
	
	public var urlImageWebsite: URL? {
		return nil
	}
	
	public var urlImageTag: URL? {
		return nil
	}
}
