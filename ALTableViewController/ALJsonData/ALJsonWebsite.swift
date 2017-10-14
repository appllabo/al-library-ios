import SwiftyJSON

public class ALJsonWebsite {
    internal var json: JSON
    
	public var name: String {
		return "name"
	}
	
	public var url: String {
		return "http://blog.livedoor.com/blog_portal/common/img/noimg/bg_Default.png"
	}
	
	public var id: Int {
		return -1
	}
	
	public var img: String {
		return "http://blog.livedoor.com/blog_portal/common/img/noimg/bg_Default.png"
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
}
