import UIKit
import AlamofireImage

public class ALWebsiteTableViewCellSetting : NSObject {
    public var tintColor = UIColor.black
	public var sizeImage = CGSize(width: 29, height: 29)
	public var radiusImage = CGFloat(14.5)
    public var font = UIFont.systemFont(ofSize: 17)
    public var colorText = UIColor.black
    public var colorTextDetail = UIColor.black
    
    public var reuseIdentifier: String {
        "ALWebsiteTableViewCell"
    }
    
    public var separatorInset: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 59, bottom: 0, right: 0)
    }
}

class ALWebsiteTableViewCell : UITableViewCell {
    private let setting: ALWebsiteTableViewCellSetting
    
    internal var website: ALWebsite?
    internal var websiteLayouted: ALWebsite?
    
	init(setting: ALWebsiteTableViewCellSetting) {
        self.setting = setting
        
        super.init(style: .default, reuseIdentifier: setting.reuseIdentifier)
		
        self.imageView?.run {
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.borderWidth = 0
            $0.layer.cornerRadius = setting.radiusImage
        }
        
		self.accessoryType = .disclosureIndicator
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let website = self.website else {
            return
        }
        
        if website == self.websiteLayouted {
            return
        }
        
        self.websiteLayouted = website
        
        self.layout(website: website)
    }
    
    public func layout(website: ALWebsite) {
        if let url = website.urlImage {
            let request = URLRequest(url: url)
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: self.setting.sizeImage, radius: self.setting.radiusImage)
            self.imageView?.image = UIImage()
            
            ImageDownloader.default.download(request, filter: filter) { [weak self] response in
                guard let image = response.result.value else {
                    return
                }
                
                self?.imageView?.image = image
                
                self?.setNeedsLayout()
            }
        }
        
        self.textLabel?.run {
            $0.text = website.name
            $0.font = setting.font
            $0.textColor = setting.colorText
        }
    }
}
