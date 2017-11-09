import SwiftyJSON

public class ALData: NSObject, NSCoding {
	internal var json: JSON
	
	public var string: String {
		return "\(self.json)"
	}
	
	init(string: String) {
		self.json = JSON(parseJSON: string)
	}
	
	init(dictionary: Any) {
		self.json = JSON(dictionary)
	}
	
	init(json: JSON) {
		self.json = json
	}
	
	public func encode(with aCoder: NSCoder) {
		if let dictionary = self.json.dictionaryObject {
			aCoder.encode(dictionary, forKey: "dictionary")
		} else {
			print("Error ALJsonData:encode")
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		guard let dictionary = aDecoder.decodeObject(forKey: "dictionary") else {
			print("Error ALJsonData:init")
			
			return nil	
		}
		
		self.json = JSON(dictionary)
	}
}

