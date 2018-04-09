import UIKit
import AlamofireImage

public class ALWebsiteTableViewCellSetting {
    public var tintColor = UIColor.black
	public var sizeImage = CGSize(width: 29, height: 29)
	public var radiusImage = CGFloat(14.5)
    public var font = UIFont.systemFont(ofSize: 17)
    public var colorText = UIColor.black
    public var colorTextDetail = UIColor.black
	
	public init() {
		
	}
}

class ALWebsiteTableViewCell: UITableViewCell {
	init(website: ALWebsite, setting: ALWebsiteTableViewCellSetting) {
		super.init(style: .default, reuseIdentifier: "ALWebsiteTableViewCell")
		
		self.imageView?.layer.masksToBounds = true
		self.imageView?.layer.borderColor = UIColor.clear.cgColor
		self.imageView?.layer.borderWidth = 0
		self.imageView?.layer.cornerRadius = setting.radiusImage
		
		if let url = website.urlImage {
            let placeholderImage = UIImage()
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: setting.sizeImage, radius: setting.radiusImage)
            self.imageView?.af_setImage(withURL: url, placeholderImage: placeholderImage, filter: filter)
		}
		
		self.textLabel?.text = website.name
        self.textLabel?.font = setting.font
        self.textLabel?.textColor = setting.colorText
		self.accessoryType = .disclosureIndicator
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension UIImage {
	func resize(size: CGSize) -> UIImage? {
		let widthRatio = size.width / self.size.width
		let heightRatio = size.height / self.size.height
		let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
		
		let resizedSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
		
		UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
		draw(in: CGRect(origin: .zero, size: resizedSize))
		let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return resizedImage
	}
	
	func change(color: UIColor) -> UIImage? {
		var image = withRenderingMode(.alwaysTemplate)
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		color.set()
		image.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
		image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return image
	}
}
