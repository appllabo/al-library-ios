import UIKit
import AlamofireImage
import SkeletonView

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
    public var backgroundColorComponent = UIColor.clear
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
        $0.clipsToBounds = true
		$0.isSkeletonable = true
    }
    
	private let labelTitle = UILabel().apply {
        $0.numberOfLines = 3
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        $0.clipsToBounds = true
		$0.isSkeletonable = true
    }
    
	private let labelDate = UILabel().apply {
        $0.textAlignment = .right
        $0.clipsToBounds = true
		$0.isSkeletonable = true
    }
    
	private let labelWebsite = UILabel().apply {
        $0.textAlignment = .left
		$0.setContentHuggingPriority(UILayoutPriority(rawValue: 0), for: .horizontal)
		$0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 0), for: .horizontal)
        $0.clipsToBounds = true
		$0.isSkeletonable = true
    }
    
	private let imageViewWebsite = UIImageView().apply {
        $0.contentMode = .center
        $0.clipsToBounds = true
		$0.isSkeletonable = true
    }
    
	private let stackViewBottom = UIStackView().apply {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 4
		$0.isSkeletonable = true
    }
    
	private let stackViewRight = UIStackView().apply {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
		$0.isSkeletonable = true
    }
	
	public init(website setting: ALWebsiteArticleTableViewCellSetting) {
        self.setting = setting
        
		super.init(setting: setting)
        
		self.labelTitle.run {
			$0.font = self.setting.fontTitle
			$0.textColor = self.setting.colorTitle
			$0.backgroundColor = self.setting.backgroundColorComponent
		}
        
		self.labelDate.run {
			$0.font = self.setting.fontDate
			$0.textColor = self.setting.colorDate
			$0.backgroundColor = self.setting.backgroundColorComponent
		}
        
		self.labelWebsite.run {
			$0.font = self.setting.fontWebsite
			$0.textColor = self.setting.colorWebsite
			$0.backgroundColor = self.setting.backgroundColorComponent
		}
        
		self.imageViewWebsite.run {
			$0.tintColor = self.setting.tintColor
			$0.backgroundColor = self.setting.backgroundColorComponent
			$0.heightAnchor.constraint(equalToConstant: self.setting.radiusWebsiteImage * 2.0).isActive = true
			$0.widthAnchor.constraint(equalToConstant: self.setting.radiusWebsiteImage * 2.0).isActive = true
		}
        
		self.stackViewBottom.run {
			$0.addArrangedSubview(self.imageViewWebsite)
			$0.addArrangedSubview(self.labelWebsite)
			$0.addArrangedSubview(self.labelDate)
		}
        
		self.stackViewRight.run {
			$0.addArrangedSubview(self.labelTitle)
        	$0.addArrangedSubview(self.stackViewBottom)
		}
        
		self.contentView.run {
			$0.isSkeletonable = true
			
			$0.addSubview(self.imageViewThumbnail)
        	$0.addSubview(self.stackViewRight)
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSkeleton() {
		self.imageViewThumbnail.frame = CGRect(x: 0, y: 0, width: self.setting.sizeThumbnail.width, height: self.setting.sizeThumbnail.height).inset(by: self.setting.paddingThumbnail)
		
		let widthRight = self.contentView.frame.width - self.setting.sizeThumbnail.width - self.setting.paddingContent.left - self.setting.paddingContent.right
		let heightRight = self.contentView.frame.height - self.setting.paddingContent.top - self.setting.paddingContent.bottom
		
		self.stackViewBottom.frame = CGRect(x: self.setting.sizeThumbnail.width + self.setting.paddingContent.left, y: self.setting.paddingContent.top + heightRight - 20, width: widthRight, height: 20)
		self.labelTitle.frame = CGRect(x: self.setting.sizeThumbnail.width + self.setting.paddingContent.left, y: self.setting.paddingContent.top, width: widthRight, height: heightRight - 20)
		
		self.contentView.showAnimatedGradientSkeleton()
	}
	
    override func layout(alArticle: ALArticle) {
		self.contentView.hideSkeleton()
		
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
