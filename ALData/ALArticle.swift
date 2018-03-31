import SwiftyJSON
import AlamofireImage

public class ALArticle: ALData {
    public var isRead = false
    
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
	
    public func loadImage(block: @escaping (UIImage) -> Void) {
        if let img = self.img, let url = URL(string: img) {
            let urlRequest = URLRequest(url: url)
            
            ImageDownloader.default.download(urlRequest) {response in
                if let image = response.result.value {
                    block(image)
                }
            }
        }
    }
    
    public func loadWebsiteImage(block: @escaping (UIImage) -> Void) {
        if let websiteImage = self.websiteImage, let url = URL(string: websiteImage) {
            let urlRequest = URLRequest(url: url)
            
            ImageDownloader.default.download(urlRequest) {response in
                if let image = response.result.value {
                    block(image)
                }
            }
        }
    }
    
    public var date: String {
        return "date"
    }
    
	public var img: String? {
		return nil
	}
	
	public var websiteImage: String? {
		return nil
	}
	
	public var tagImage: String? {
		return nil
	}
}
