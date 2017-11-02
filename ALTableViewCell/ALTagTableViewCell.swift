import UIKit
import AlamofireImage

public class ALTagTableViewCellSetting {
	public var sizeImage = CGSize(width: 29, height: 29)
	public var radiusImage = CGFloat(14.5)
	
	public init() {
		
	}
}

class ALTagTableViewCell: UITableViewCell {
	init(tag: ALJsonTag, setting: ALTagTableViewCellSetting) {
		super.init(style: .value1, reuseIdentifier: "ALTagTableViewCell")
		
		/*
		self.imageView?.layer.masksToBounds = true
		self.imageView?.layer.borderColor = UIColor.clear.cgColor
		self.imageView?.layer.borderWidth = 0
		self.imageView?.layer.cornerRadius = setting.radiusImage
		
		let url = NSURL(string: website.img)!
		let placeholderImage = UIImage(named: "Resource/Library/User.gif")!.resize(size: setting.sizeImage)
		let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: setting.sizeImage, radius: setting.radiusImage)
		self.imageView?.af_setImage(withURL: url as URL, placeholderImage: placeholderImage, filter: filter)
		*/
		
		self.textLabel?.text = tag.name
		self.detailTextLabel?.text = String(tag.contentCount)
		self.detailTextLabel?.textAlignment = .right
		
		self.accessoryType = .disclosureIndicator
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
