import UIKit
import AlamofireImage

public class ALImageArticleTableViewCellSetting : ALArticleTableViewCellSetting {
    public override var reuseIdentifier: String {
        return "ALImageArticle"
    }
    
    public override var separatorInset: UIEdgeInsets? {
        return UIEdgeInsets(top: 0, left: self.paddingThumbnail.left, bottom: 0, right: 0)
    }
    
    public var sizeThumbnail = CGSize(width: 102.0, height: 102.0)
    public var paddingThumbnail = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    public var paddingContent = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 12)
    public var radiusThumbnail = CGFloat(4.0)
    public var backgroundColor = UIColor.white
    public var fontTitle = UIFont.boldSystemFont(ofSize: 20)
    public var fontDate = UIFont.systemFont(ofSize: 14)
    public var fontWebsite = UIFont.systemFont(ofSize: 14)
    public var colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
    public var colorTitleRead = UIColor(hex: 0x707070, alpha: 1.0)
    public var colorDate = UIColor(hex: 0xa0a0a0, alpha: 1.0)
    public var colorWebsite = UIColor(hex: 0xa0a0a0, alpha: 1.0)
    public var tintColor = UIColor.black
	public var paddingInfo = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
	public var paddingTitle = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
	public var radiusWebsiteImage = CGFloat(10)
	public var colorBottom = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	
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

public class ALImageArticleTableViewCell : ALArticleTableViewCell {
	private let setting: ALImageArticleTableViewCellSetting
	
    private let imageViewThumbnail = UIImageView()
    private let labelTitle = UILabel()
    private let labelDate = UILabel()
    private let labelWebsite = UILabel()
	private let imageViewWebsite = UIImageView()
	private let stackViewInfo = UIStackView()
	
	public init(image setting: ALImageArticleTableViewCellSetting) {
        self.setting = setting
        
		super.init(setting: setting)
        
        self.labelTitle.font = self.setting.fontTitle
        self.labelTitle.numberOfLines = 2
        self.labelTitle.textAlignment = .left
        self.labelTitle.lineBreakMode = .byTruncatingTail
        self.labelTitle.textColor = self.setting.colorTitle
        self.labelTitle.backgroundColor = .white
        self.labelTitle.clipsToBounds = true
        
        self.imageViewThumbnail.contentMode = .center
        self.imageViewThumbnail.backgroundColor = .white
        self.imageViewThumbnail.clipsToBounds = true
        
        self.initStackView()
        
        self.contentView.addSubview(self.labelTitle)
        self.contentView.addSubview(self.imageViewThumbnail)
        self.contentView.addSubview(self.stackViewInfo)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func initStackView() {
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
		
		self.stackViewInfo.axis = .horizontal
		self.stackViewInfo.alignment = .center
		self.stackViewInfo.distribution = .fill
		self.stackViewInfo.spacing = 4
		
		self.stackViewInfo.addArrangedSubview(self.imageViewWebsite)
		self.stackViewInfo.addArrangedSubview(self.labelWebsite)
		self.stackViewInfo.addArrangedSubview(self.labelDate)
	}
	
	override func layout(alArticle: ALArticle) {
        let width = self.contentView.frame.width
            
		self.labelTitle.frame = self.setting.rectTitle(width: width)
        self.imageViewThumbnail.frame = self.setting.rectThumbnail(width: width)
		self.stackViewInfo.frame = self.setting.rectStack(width: width)
        
        self.labelTitle.text = alArticle.title
        self.labelDate.text = alArticle.date
        self.labelWebsite.text = alArticle.website
        
        self.imageViewThumbnail.image = nil
        
        if let image = alArticle.imageThumbnail {
            self.imageViewThumbnail.image = image
        } else {
            let widthThumbnail = width - self.setting.paddingThumbnail.left - self.setting.paddingThumbnail.right
            let heightThumbnail = widthThumbnail / 16 * 9
            let filterThumbnail = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: widthThumbnail, height: heightThumbnail), radius: self.setting.radiusThumbnail)
            
            alArticle.loadThumbnailImage(filter: filterThumbnail, block: { image in
                if self.alArticle == alArticle {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    
                    self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
                    self.imageViewThumbnail.image = image
                }
            })
        }
        
        self.imageViewWebsite.image = nil
        
        if let image = alArticle.imageWebsite {
            self.imageViewWebsite.image = image
        } else {
            let filterWebsite = AspectScaledToFillSizeCircleFilter(size: CGSize(width: self.setting.radiusWebsiteImage * 2.0, height: self.setting.radiusWebsiteImage * 2.0))
            
            alArticle.loadWebsiteImage(filter: filterWebsite, block: { image in
                if self.alArticle == alArticle {
					let transition = CATransition().apply {
                    	$0.type = kCATransitionFade
					}
                    
                    self.imageViewWebsite.layer.add(transition, forKey: kCATransition)
                    self.imageViewWebsite.image = image
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
