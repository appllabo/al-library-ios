import UIKit
import AlamofireImage

public class ALInstaArticleTableViewCellSetting : ALArticleTableViewCellSetting {
    public override var reuseIdentifier: String {
        return "ALInstaArticle"
    }
    
    public override var separatorInset: UIEdgeInsets? {
        return UIEdgeInsets(top: 0, left: self.paddingThumbnail.left, bottom: 0, right: 0)
    }
    
    public var sizeThumbnail = CGSize(width: 102.0, height: 102.0)
    public var paddingThumbnail = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    public var paddingContent = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 12)
    public var radiusThumbnail = CGFloat(4.0)
    public var backgroundColor = UIColor.white
    public var fontTitle = UIFont.boldSystemFont(ofSize: 20)
    public var fontDate = UIFont.systemFont(ofSize: 14)
    public var fontWebsite = UIFont.boldSystemFont(ofSize: 16)
    public var colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
    public var colorTitleRead = UIColor(hex: 0x707070, alpha: 1.0)
    public var colorDate = UIColor(hex: 0xa0a0a0, alpha: 1.0)
    public var colorWebsite = UIColor(hex: 0xa0a0a0, alpha: 1.0)
    public var tintColor = UIColor.black
	public var paddingInfo = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
	public var paddingTitle = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
	public var radiusWebsiteImage = CGFloat(18)
	public var colorBottom = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	
    override func height(width: CGFloat) -> CGFloat {
        return 54 + width / 16 * 9 + 64
    }
}

public class ALInstaArticleTableViewCell: ALArticleTableViewCell {
	private let setting: ALInstaArticleTableViewCellSetting
	
    private let imageViewThumbnail = UIImageView()
    private let labelTitle = UILabel()
    private let labelDate = UILabel()
    private let labelWebsite = UILabel()
	private let imageViewWebsite = UIImageView()
	private let stackViewInfo = UIStackView()
	
	public init(setting: ALInstaArticleTableViewCellSetting) {
        self.setting = setting
        
		super.init(setting: setting)
        
        self.labelTitle.font = self.setting.fontTitle
        self.labelTitle.numberOfLines = 2
        self.labelTitle.textAlignment = .left
        self.labelTitle.lineBreakMode = .byCharWrapping
        self.labelTitle.textColor = self.setting.colorTitle
        self.labelTitle.backgroundColor = .white
        self.labelTitle.clipsToBounds = true
        
        self.initStackView(info: self.stackViewInfo)
        
        self.contentView.addSubview(self.stackViewInfo)
        self.contentView.addSubview(self.imageViewThumbnail)
        self.contentView.addSubview(self.labelTitle)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
    
	override func layout(alArticle: ALArticle) {
        let width = self.contentView.frame.width
		let widthThumbnail = width - self.setting.paddingThumbnail.left - self.setting.paddingThumbnail.right
		let heightThumbnail = widthThumbnail / 16 * 9
		
        self.stackViewInfo.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: width, height: 54), self.setting.paddingInfo)
		self.imageViewThumbnail.frame = CGRect(x: 0, y: 54, width: width, height: heightThumbnail)
        self.labelTitle.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 54 + heightThumbnail, width: width, height: 64), self.setting.paddingTitle)
        
        self.labelTitle.text = alArticle.title
        self.labelDate.text = alArticle.date
        self.labelWebsite.text = alArticle.website
        
        self.imageViewThumbnail.image = nil
        
        if let image = alArticle.imageThumbnail {
            self.imageViewThumbnail.image = image
        } else {
            let filterThumbnail = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: widthThumbnail, height: heightThumbnail), radius: self.setting.radiusThumbnail)
            
            alArticle.loadThumbnailImage(filter: filterThumbnail, block: {image in
                if self.alArticle == alArticle {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    
                    self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
                    self.imageViewThumbnail.image = image
                }
            })
        }
        
        self.imageViewWebsite.image = nil
        
        if let image = alArticle.imageThumbnail {
            self.imageViewThumbnail.image = image
        } else {
            let filter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: 100.0, height: 100.0))
            
            alArticle.loadThumbnailImage(filter: filter, block: {image in
                if self.alArticle == alArticle {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    
                    self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
                    self.imageViewThumbnail.image = image
                }
            })
        }
    }
    
    override func read() {
        self.labelTitle.textColor = self.setting.colorTitleRead
    }
    
    override func unread() {
        self.labelTitle.textColor = self.setting.colorTitle
    }
}
