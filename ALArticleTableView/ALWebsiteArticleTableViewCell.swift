import UIKit
import AlamofireImage

public class ALWebsiteArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var radiusWebsiteImage = CGFloat(8.5)
	
	public override init() {
		
	}
}

public class ALWebsiteArticleTableViewCell: ALArticleTableViewCell {
	public override var reuseIdentifier: String {
		return "ALWebsiteArticle"
	}
	
	public var settingWebsite: ALWebsiteArticleTableViewCellSetting {
		return self.setting as! ALWebsiteArticleTableViewCellSetting
	}
	
	internal let imageViewWebsite = UIImageView()
	
	public override var stackViewBottom: UIStackView {
        self.imageViewWebsite.tintColor = self.setting.tintColor
        self.imageViewWebsite.contentMode = .center
        self.imageViewWebsite.heightAnchor.constraint(equalToConstant: self.settingWebsite.radiusWebsiteImage * 2.0).isActive = true
        self.imageViewWebsite.widthAnchor.constraint(equalToConstant: self.settingWebsite.radiusWebsiteImage * 2.0).isActive = true
        self.imageViewWebsite.clipsToBounds = true
        
		self.labelWebsite.font = self.settingWebsite.fontWebsite
		self.labelWebsite.textAlignment = .left
		self.labelWebsite.textColor = self.settingWebsite.colorWebsite
		self.labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		self.labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
        self.labelWebsite.backgroundColor = .white
        self.labelWebsite.clipsToBounds = true
		
		self.labelDate.font = self.settingWebsite.fontDate
		self.labelDate.textAlignment = .right
		self.labelDate.textColor = self.setting.colorDate
        self.labelDate.backgroundColor = .white
        self.labelDate.clipsToBounds = true
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.spacing = 4
		
		stackView.addArrangedSubview(self.imageViewWebsite)
		stackView.addArrangedSubview(self.labelWebsite)
		stackView.addArrangedSubview(self.labelDate)
		
		return stackView
	}
	
	public init(setting: ALWebsiteArticleTableViewCellSetting) {
		super.init(setting: setting)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override public func initView() {
        super.initView()
    }
    
    override func layout() {
        guard let article = self.alArticle else {
            return
        }
        
        if article == self.alArticleLayouted {
            return
        }
        
        self.imageViewThumbnail.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: self.setting.sizeThumbnail.width, height: self.setting.sizeThumbnail.height), self.setting.paddingThumbnail)
        
        let widthRight = self.contentView.frame.width - self.setting.sizeThumbnail.width - self.setting.paddingContent.left - self.setting.paddingContent.right
        let heightRight = self.contentView.frame.height - self.setting.paddingContent.top - self.setting.paddingContent.bottom
        
        self.stackViewRight.frame = CGRect(x: self.setting.sizeThumbnail.width + self.setting.paddingContent.left, y: self.setting.paddingContent.top, width: widthRight, height: heightRight)
        
        self.alArticleLayouted = article
        
        self.labelTitle.text = article.title
        self.labelDate.text = article.date
        self.labelWebsite.text = article.website
        
        self.imageViewThumbnail.image = nil
        
        if let image = article.imageThumbnail {
            self.imageViewThumbnail.image = image
        } else {
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.setting.sizeThumbnail.width - self.setting.paddingThumbnail.left - self.setting.paddingThumbnail.right, height: self.setting.sizeThumbnail.height - self.setting.paddingThumbnail.top - self.setting.paddingThumbnail.bottom), radius: self.setting.radiusThumbnail)
            
            article.loadThumbnailImage(filter: filter, block: {image in
                if self.alArticle == article {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    
                    self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
                    self.imageViewThumbnail.image = image
                }
            })
        }
        
        self.imageViewWebsite.image = nil
        
        if let image = self.alArticle?.imageWebsite {
            self.imageViewWebsite.image = image
        } else {
            let filter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: self.settingWebsite.radiusWebsiteImage * 2.0, height: self.settingWebsite.radiusWebsiteImage * 2.0))
            
            self.alArticle?.loadWebsiteImage(filter: filter, block: {image in
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
