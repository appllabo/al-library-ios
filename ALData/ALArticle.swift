import SwiftyJSON
import AlamofireImage

public class ALArticle: ALData {
    public var isRead = false
	public var imageThumbnail: UIImage?
	public var imageWebsite: UIImage?
	
	public var title: String {
		return "title"
	}
	
	public var url: String {
		return "url"
	}
	
	public var website: String {
		return "website"
	}
	
	public var stringTags: String {
		return "tags"
	}
	
    public func loadThumbnailImage(block: @escaping (UIImage) -> Void) {
        if let urlImage = self.urlImageThumbnail, let url = URL(string: urlImage) {
            let urlRequest = URLRequest(url: url)
            
            ImageDownloader.default.download(urlRequest) {response in
                if let image = response.result.value {
					self.imageThumbnail = image
					
                    block(image)
                }
            }
        }
    }
    
    public func loadWebsiteImage(block: @escaping (UIImage) -> Void) {
        if let urlImageWebsite = self.urlImageWebsite, let url = URL(string: urlImageWebsite) {
            let urlRequest = URLRequest(url: url)
            
            ImageDownloader.default.download(urlRequest) {response in
                if let image = response.result.value {
					self.imageWebsite = image
					
                    block(image)
                }
            }
        }
    }
    
    public var date: String {
        return "date"
    }
    
	public var urlImageThumbnail: String? {
		return nil
	}
	
	public var urlImageWebsite: String? {
		return nil
	}
	
	public var urlImageTag: String? {
		return nil
	}
}
