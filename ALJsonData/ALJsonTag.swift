import SwiftyJSON

public class ALJsonTag: NSObject, NSCoding {
	internal var json: JSON
	
	public var name: String? {
		return nil
	}
	
	public var id: String {
		return "id"
	}
	
	public var img: String {
		return "http://blog.livedoor.com/blog_portal/common/img/noimg/bg_Default.png"
	}
	
	public var contentCount: Int {
		return 0
	}
	
	public var string: String {
		return "\(self.json)"
	}
	
	init(json: JSON) {
		self.json = json
	}
	
	public func encode(with aCoder: NSCoder) {
		if let dictionary = self.json.dictionaryObject {
			aCoder.encode(dictionary, forKey: "dictionary")
		} else {
			print("Error ALJsonTag:encode")
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		guard let dictionary = aDecoder.decodeObject(forKey: "dictionary") else {
			print("Error ALJsonTag:init")
			
			return nil	
		}
		
		self.json = JSON(dictionary)
	}
}
