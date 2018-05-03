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
    private let website: ALWebsite
    private let setting: ALWebsiteTableViewCellSetting
    
	init(website: ALWebsite, setting: ALWebsiteTableViewCellSetting) {
        self.website = website
        self.setting = setting
        
		super.init(style: .default, reuseIdentifier: "ALWebsiteTableViewCell")
		
		self.imageView?.layer.masksToBounds = true
		self.imageView?.layer.borderColor = UIColor.clear.cgColor
		self.imageView?.layer.borderWidth = 0
		self.imageView?.layer.cornerRadius = setting.radiusImage
		
        if let url = website.urlImage {
            let urlRequest = URLRequest(url: url)
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: self.setting.sizeImage, radius: self.setting.radiusImage)
            
            ImageDownloader.default.download(urlRequest, filter: filter) {[weak self] response in
                if let image = response.result.value {
                    self?.imageView?.image = image
                    
                    self?.setNeedsLayout()
                }
            }
        }
        
		self.textLabel?.text = website.name
        self.textLabel?.font = setting.font
        self.textLabel?.textColor = setting.colorText
		self.accessoryType = .disclosureIndicator
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layout()
    }
    
    public func layout() {
//        if let url = website.urlImage, self.imageView?.image == nil {
//            let placeholderImage = UIImage()
//            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: self.setting.sizeImage, radius: self.setting.radiusImage)
//            self.imageView?.af_setImage(withURL: url, placeholderImage: placeholderImage, filter: filter)
//        }
    }
}
