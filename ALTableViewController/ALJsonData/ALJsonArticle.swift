import SwiftyJSON

public class ALJsonArticle: NSObject, NSCoding {
	internal var json: JSON
	
	public var title: String {
		return "title"
	}
	
	public var url: String {
		return "url"
	}
	
	public var website: String {
		return "website"
	}
	
	public var img: String {
		return "img"
	}
	
	public var date: String {
		return "date"
	}
	
	public var websiteImage: String {
		return "http://blog.livedoor.com/blog_portal/common/img/noimg/bg_Default.png"
	}
	
	public var isRead: Bool {
		get {
			return self.json["isRead"].bool ?? false
		}
		
		set(value) {
			self.json["isRead"].bool = value
		}
	}
	
	public var string: String {
		return "\(self.json)"
	}
	
    init(string: String) {
		self.json = JSON(parseJSON: string)
    }
    
    init(json: JSON) {
        self.json = json
    }
	
	public func encode(with aCoder: NSCoder) {
		if let dictionary = self.json.dictionaryObject {
			aCoder.encode(dictionary, forKey: "dictionary")
		} else {
			print("Error ALJsonArticle:encode")
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		guard let dictionary = aDecoder.decodeObject(forKey: "dictionary") else {
			print("Error ALJsonArticle:init")
			
			return nil	
		}
		
		self.json = JSON(dictionary)
	}
}
