import SwiftyJSON

public class ALArticle: ALData {
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
	
	public var img: String? {
		return nil
	}
	
	public var date: String {
		return "date"
	}
	
	public var websiteImage: String? {
		return nil
	}
	
	public var tagImage: String? {
		return nil
	}
	
	public var isRead: Bool {
		get {
			return self.json["isRead"].bool ?? false
		}
		
		set(value) {
			self.json["isRead"].bool = value
		}
	}
}
