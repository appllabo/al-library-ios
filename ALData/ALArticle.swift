import SwiftyJSON
import AlamofireImage

public class ALArticle : ALData {
    public var isRead = false
	public var imageThumbnail: UIImage?
	public var imageWebsite: UIImage?
    public var imageTag: UIImage?
	
	public var title: String? {
		nil
	}
	
	public var website: String? {
		nil
	}
	
	public var stringTags: String? {
		nil
	}
	
    public var date: String? {
        nil
    }
    
    public var url: URL? {
        nil
    }
    
    public var urlImageThumbnail: URL? {
        nil
    }
    
    public var urlImageWebsite: URL? {
        nil
    }
    
    public var urlImageTag: URL? {
        nil
    }
    
    public func loadThumbnailImage(filter: ImageFilter, block: @escaping (UIImage) -> Void) {
        guard let url = self.urlImageThumbnail else {
            return
        }
        
        let request = URLRequest(url: url)
        
        ImageDownloader.default.download(request, filter: filter) { response in
            guard let image = response.result.value else {
                print(url.relativeString)
                print(response)
                
                return
            }
            
            self.imageThumbnail = image
            
            block(image)
        }
    }
    
    public func loadWebsiteImage(filter: ImageFilter, block: @escaping (UIImage) -> Void) {
        guard let url = self.urlImageWebsite else {
            return
        }
        
        let request = URLRequest(url: url)
        
        ImageDownloader.default.download(request, filter: filter) { response in
            guard let image = response.result.value else {
                return
            }
            
            self.imageWebsite = image
            
            block(image)
        }
    }
    
    public func loadTagImage(filter: CompositeImageFilter, block: @escaping (UIImage) -> Void) {
        guard let url = self.urlImageTag else {
            return
        }
        
        let request = URLRequest(url: url)
        
        ImageDownloader.default.download(request, filter: filter) { response in
            guard let image = response.result.value else {
                return
            }
            
            self.imageTag = image
            
            block(image)
        }
    }
}
