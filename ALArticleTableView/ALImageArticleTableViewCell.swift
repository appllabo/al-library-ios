import UIKit
import AlamofireImage

public class ALImageArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var paddingInfo = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
	public var paddingTitle = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
	public var radiusWebsiteImage = CGFloat(10)
	public var colorBottom = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	
	public override init() {
		super.init()
		
        self.radiusThumbnail = CGFloat(4.0)
		self.paddingThumbnail = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        self.fontTitle = .boldSystemFont(ofSize: 20)
		self.fontWebsite = .systemFont(ofSize: 14)
		self.fontDate = .systemFont(ofSize: 14)
		self.backgroundColor = UIColor.clear
		self.colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
		self.colorTitleRead = UIColor(hex: 0x707070, alpha: 1.0)
        self.colorWebsite = UIColor(hex: 0xa0a0a0, alpha: 1.0)
        self.colorDate = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	}
    
    override func height(width: CGFloat) -> CGFloat {
        return 64 + width / 16 * 9 + 44
    }
    
    func rectTitle(width: CGFloat) -> CGRect {
        return UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: width, height: 64), self.paddingTitle)
    }
    
    func rectThumbnail(width: CGFloat) -> CGRect {
        return UIEdgeInsetsInsetRect(CGRect(x: 0, y: 64, width: width, height: width / 16 * 9), self.paddingThumbnail)
    }
    
    func rectStack(width: CGFloat) -> CGRect {
        return UIEdgeInsetsInsetRect(CGRect(x: 0, y: 64 + width / 16 * 9, width: width, height: 44), self.paddingInfo)
    }
}

public class ALImageArticleTableViewCell: ALArticleTableViewCell {
	public override var reuseIdentifier: String {
		return "ALImageArticle"
	}
	
	public var settingImage: ALImageArticleTableViewCellSetting {
		return self.setting as! ALImageArticleTableViewCellSetting
	}
	
	internal let imageViewWebsite = UIImageView()
	internal let stackViewInfo = UIStackView()
	
	public init(setting: ALImageArticleTableViewCellSetting) {
		super.init(setting: setting)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func initView() {
		self.labelTitle.font = self.setting.fontTitle
		self.labelTitle.numberOfLines = 2
		self.labelTitle.textAlignment = .left
		self.labelTitle.textColor = self.setting.colorTitle
        self.labelTitle.backgroundColor = .white
        self.labelTitle.clipsToBounds = true
		
        self.imageViewThumbnail.contentMode = .center
        self.imageViewThumbnail.backgroundColor = .white
        self.imageViewThumbnail.clipsToBounds = true
        
		self.initStackView(info: self.stackViewInfo)
		
        self.contentView.addSubview(self.labelTitle)
        self.contentView.addSubview(self.imageViewThumbnail)
		self.contentView.addSubview(self.stackViewInfo)
	}
	
	internal func initStackView(info: UIStackView) {
        self.imageViewWebsite.tintColor = self.setting.tintColor
        self.imageViewWebsite.setContentHuggingPriority(1, for: .horizontal)
        self.imageViewWebsite.setContentCompressionResistancePriority(1, for: .horizontal)
        self.imageViewWebsite.contentMode = .center
        self.imageViewWebsite.clipsToBounds = true
        
		self.labelWebsite.font = self.setting.fontWebsite
		self.labelWebsite.textAlignment = .left
		self.labelWebsite.textColor = self.setting.colorWebsite
		self.labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		self.labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
        self.labelWebsite.backgroundColor = .white
        self.labelWebsite.clipsToBounds = true
        
		self.labelDate.font = self.setting.fontDate
		self.labelDate.textAlignment = .right
		self.labelDate.textColor = self.setting.colorDate
        self.labelDate.setContentHuggingPriority(1, for: .horizontal)
        self.labelDate.backgroundColor = .white
        self.labelDate.clipsToBounds = true
		
		info.axis = .horizontal
		info.alignment = .center
		info.distribution = .fill
		info.spacing = 4
		
		info.addArrangedSubview(self.imageViewWebsite)
		info.addArrangedSubview(self.labelWebsite)
		info.addArrangedSubview(self.labelDate)
	}
	
	override func layout() {
		self.labelTitle.frame = self.settingImage.rectTitle(width: self.contentView.frame.width)
        self.imageViewThumbnail.frame = self.settingImage.rectThumbnail(width: self.contentView.frame.width)
		self.stackViewInfo.frame = self.settingImage.rectStack(width: self.contentView.frame.width)
	}
	
    internal func set(article: Article, width: CGFloat) {
        self.alArticle = article
        
        self.labelTitle.text = article.title
        self.labelDate.text = article.date
        self.labelWebsite.text = article.website
        
        let widthThumbnail = width - self.setting.paddingThumbnail.left - self.setting.paddingThumbnail.right
        let heightThumbnail = widthThumbnail / 16 * 9
        
        self.imageViewThumbnail.image = nil
        
        if let image = article.imageThumbnail {
            self.imageViewThumbnail.image = image
        } else {
            let filterThumbnail = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: widthThumbnail, height: heightThumbnail), radius: self.setting.radiusThumbnail)
            
            article.loadThumbnailImage(filter: filterThumbnail, block: {image in
                if self.alArticle == article {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    
                    self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
                    self.imageViewThumbnail.image = image
                }
            })
        }
        
        self.imageViewWebsite.image = nil
        
        if let image = article.imageWebsite {
            self.imageViewWebsite.image = image
        } else {
            let filterWebsite = AspectScaledToFillSizeCircleFilter(size: CGSize(width: self.settingImage.radiusWebsiteImage * 2.0, height: self.settingImage.radiusWebsiteImage * 2.0))
            
            article.loadWebsiteImage(filter: filterWebsite, block: {image in
                if self.alArticle == article {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    
                    self.imageViewWebsite.layer.add(transition, forKey: kCATransition)
                    self.imageViewWebsite.image = image
                }
            })
        }
	}
}
