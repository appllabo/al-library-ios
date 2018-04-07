import UIKit
import AlamofireImage

public class ALInstaArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var paddingInfo = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
	public var paddingTitle = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
	public var radiusWebsiteImage = CGFloat(18)
	public var colorBottom = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	
	public override init() {
		super.init()
		
		self.paddingThumbnail = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.fontTitle = .boldSystemFont(ofSize: 20)
		self.fontWebsite = .boldSystemFont(ofSize: 16)
		self.fontDate = .systemFont(ofSize: 14)
		self.backgroundColor = .clear
		self.colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
		self.colorTitleRead = UIColor(hex: 0x707070, alpha: 1.0)
		self.colorWebsite = UIColor(hex: 0x000000, alpha: 1.0)
	}
    
    override func height(width: CGFloat) -> CGFloat {
        return 54 + width / 16 * 9 + 64
    }
}

public class ALInstaArticleTableViewCell: ALArticleTableViewCell {
	public override var reuseIdentifier: String {
		return "ALInstaArticle"
	}
	
	public var settingImage: ALInstaArticleTableViewCellSetting {
		return self.setting as! ALInstaArticleTableViewCellSetting
	}
	
	private let imageViewWebsite = UIImageView()
	private let imageViewThumbnail = UIImageView()
	private let stackViewInfo = UIStackView()
	
	public init(setting: ALInstaArticleTableViewCellSetting, isRead: @escaping () -> Bool) {
		super.init(setting: setting, isRead: isRead)
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
        
		self.initStackView(info: self.stackViewInfo)
		
		self.contentView.addSubview(self.stackViewInfo)
		self.contentView.addSubview(self.imageViewThumbnail)
		self.contentView.addSubview(self.labelTitle)
	}
	
    private func initStackView(info: UIStackView) {
        self.imageViewWebsite.contentMode = .center
        self.imageViewWebsite.clipsToBounds = true
        
        self.imageViewThumbnail.contentMode = .center
        self.imageViewThumbnail.clipsToBounds = true
        
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
        self.labelDate.backgroundColor = .white
        self.labelDate.clipsToBounds = true
        
        info.axis = .horizontal
        info.alignment = .center
        info.distribution = .fill
        info.spacing = 8
        
        info.addArrangedSubview(self.imageViewWebsite)
        info.addArrangedSubview(self.labelWebsite)
        info.addArrangedSubview(self.labelDate)
    }
    
	override func layout() {
		let widthThumbnail = self.contentView.frame.width - self.setting.paddingThumbnail.left - self.setting.paddingThumbnail.right
		let heightThumbnail = widthThumbnail / 16 * 9
		
        self.stackViewInfo.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 54), self.settingImage.paddingInfo)
		self.imageViewThumbnail.frame = CGRect(x: 0, y: 54, width: self.contentView.frame.width, height: heightThumbnail)
        self.labelTitle.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 54 + heightThumbnail, width: self.contentView.frame.width, height: 64), self.settingImage.paddingTitle)
    }
    
	internal func set(article: Article, width: CGFloat) {
		super.set(alArticle: article)
        let filter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: 100.0, height: 100.0))
		
        article.loadThumbnailImage(filter: filter, block: {image in
			self.imageViewThumbnail.image = image
			
			let transition = CATransition()
			transition.type = kCATransitionFade
			
			self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
		})
		
		article.loadWebsiteImage(filter: filter, block: {image in
			self.imageViewWebsite.image = image
		})
	}
}
