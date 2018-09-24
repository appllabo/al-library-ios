import UIKit
import AlamofireImage

public class ALWebsiteArticleTableViewCellSetting : ALArticleTableViewCellSetting {
    public override var reuseIdentifier: String {
        return "ALWebsiteArticle"
    }
    
    public override var separatorInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: self.paddingThumbnail.left, bottom: 0, right: 0)
    }
    
    public var sizeThumbnail = CGSize(width: 102.0, height: 102.0)
    public var paddingThumbnail = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    public var paddingContent = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 12)
    public var radiusThumbnail = CGFloat(4.0)
    public var backgroundColor = UIColor.white
    public var fontTitle = UIFont.boldSystemFont(ofSize: 16)
    public var fontDate = UIFont.systemFont(ofSize: 12)
    public var fontWebsite = UIFont.systemFont(ofSize: 12)
    public var colorTitle = UIColor(hex: 0x000000)
    public var colorTitleRead = UIColor(hex: 0x707070)
    public var colorDate = UIColor(hex: 0xa0a0a0)
    public var colorWebsite = UIColor(hex: 0xa0a0a0)
    public var tintColor = UIColor.black
	public var radiusWebsiteImage = CGFloat(8.5)
	
    override func height(width: CGFloat) -> CGFloat {
        return sizeThumbnail.height
    }
}

public class ALWebsiteArticleTableViewCell : ALArticleTableViewCell {
    private let setting: ALWebsiteArticleTableViewCellSetting
    
	private let imageViewThumbnail = UIImageView().apply {
        $0.contentMode = .center
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
	private let labelTitle = UILabel().apply {
        $0.numberOfLines = 3
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
	private let labelDate = UILabel().apply {
        $0.textAlignment = .right
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
	private let labelWebsite = UILabel().apply {
        $0.textAlignment = .left
		$0.setContentHuggingPriority(UILayoutPriority(rawValue: 0), for: .horizontal)
		$0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 0), for: .horizontal)
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
	private let imageViewWebsite = UIImageView().apply {
        $0.contentMode = .center
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
	private let stackViewBottom = UIStackView().apply {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 4
    }
    
	private let stackViewRight = UIStackView().apply {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
	
	public init(website setting: ALWebsiteArticleTableViewCellSetting) {
        self.setting = setting
        
		super.init(setting: setting)
        
        self.labelTitle.font = self.setting.fontTitle
        self.labelTitle.textColor = self.setting.colorTitle
        
        self.labelDate.font = self.setting.fontDate
        self.labelDate.textColor = self.setting.colorDate
        
        self.labelWebsite.font = self.setting.fontWebsite
        self.labelWebsite.textColor = self.setting.colorWebsite
        
        self.imageViewWebsite.tintColor = self.setting.tintColor
        self.imageViewWebsite.heightAnchor.constraint(equalToConstant: self.setting.radiusWebsiteImage * 2.0).isActive = true
        self.imageViewWebsite.widthAnchor.constraint(equalToConstant: self.setting.radiusWebsiteImage * 2.0).isActive = true
        
        self.stackViewBottom.addArrangedSubview(self.imageViewWebsite)
        self.stackViewBottom.addArrangedSubview(self.labelWebsite)
        self.stackViewBottom.addArrangedSubview(self.labelDate)
        
        self.stackViewRight.addArrangedSubview(self.labelTitle)
        self.stackViewRight.addArrangedSubview(self.stackViewBottom)
        
        self.contentView.addSubview(self.imageViewThumbnail)
        self.contentView.addSubview(self.stackViewRight)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func layout(alArticle: ALArticle) {
        self.imageViewThumbnail.frame = CGRect(x: 0, y: 0, width: self.setting.sizeThumbnail.width, height: self.setting.sizeThumbnail.height).inset(by: self.setting.paddingThumbnail)
        
        let widthRight = self.contentView.frame.width - self.setting.sizeThumbnail.width - self.setting.paddingContent.left - self.setting.paddingContent.right
        let heightRight = self.contentView.frame.height - self.setting.paddingContent.top - self.setting.paddingContent.bottom
        
        self.stackViewRight.frame = CGRect(x: self.setting.sizeThumbnail.width + self.setting.paddingContent.left, y: self.setting.paddingContent.top, width: widthRight, height: heightRight)
        
        self.labelTitle.text = alArticle.title
        self.labelDate.text = alArticle.date
        self.labelWebsite.text = alArticle.website
        
        self.imageViewThumbnail.image = nil
        
        if let image = alArticle.imageThumbnail {
            self.imageViewThumbnail.image = image
        } else {
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.setting.sizeThumbnail.width - self.setting.paddingThumbnail.left - self.setting.paddingThumbnail.right, height: self.setting.sizeThumbnail.height - self.setting.paddingThumbnail.top - self.setting.paddingThumbnail.bottom), radius: self.setting.radiusThumbnail)
            
            alArticle.loadThumbnailImage(filter: filter) { image in
                if self.alArticle != alArticle {
					return
				}
				
				let transition = CATransition().apply {
					$0.type = .fade
				}
				
				self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
				self.imageViewThumbnail.image = image
            }
        }
        
        self.imageViewWebsite.image = nil
        
        if let image = self.alArticle?.imageWebsite {
            self.imageViewWebsite.image = image
        } else {
            let filter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: self.setting.radiusWebsiteImage * 2.0, height: self.setting.radiusWebsiteImage * 2.0))
            
            self.alArticle?.loadWebsiteImage(filter: filter) { image in
                if self.alArticle != alArticle {
					return
				}
				
				let transition = CATransition().apply {
					$0.type = .fade
				}
				
				self.imageViewWebsite.layer.add(transition, forKey: kCATransition)
				self.imageViewWebsite.image = image
            }
        }
    }
    
    override func read() {
        self.labelTitle.textColor = self.setting.colorTitleRead
    }
    
    override func unread() {
        self.labelTitle.textColor = self.setting.colorTitle
    }
}
