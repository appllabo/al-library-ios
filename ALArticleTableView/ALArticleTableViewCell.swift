import UIKit
import AlamofireImage

public class ALArticleTableViewCellSetting {
    public var sizeThumbnail = CGSize(width: 102.0, height: 102.0)
	public var paddingThumbnail = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
	public var paddingContent = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 12)
    public var radiusThumbnail = CGFloat(4.0)
    public var backgroundColor = UIColor.white
    public var fontTitle = UIFont.boldSystemFont(ofSize: 17)
    public var fontDate = UIFont.systemFont(ofSize: 12)
    public var fontWebsite = UIFont.systemFont(ofSize: 12)
	public var colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
	public var colorTitleRead = UIColor(hex: 0x707070, alpha: 1.0)
	public var colorDate = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	public var colorWebsite = UIColor(hex: 0xa0a0a0, alpha: 1.0)
    public var tintColor = UIColor.black
	
	public init() {
	}
    
    func height(width: CGFloat) -> CGFloat {
        return self.sizeThumbnail.height
    }
}

public class ALArticleTableViewCell: UITableViewCell {
	public override var reuseIdentifier: String {
		return "ALArticle"
	}
	
	public let setting: ALArticleTableViewCellSetting
	
	internal let imageViewThumbnail = UIImageView()
	internal let labelTitle = UILabel()
    internal let labelDate = UILabel()
    internal let labelWebsite = UILabel()
	internal let stackViewRight = UIStackView()
	
    internal var alArticle: ALArticle?
	
	public var stackViewBottom: UIStackView {
		self.labelDate.font = self.setting.fontDate
		self.labelDate.textAlignment = .left
		self.labelDate.textColor = self.setting.colorDate
		self.labelDate.backgroundColor = .white
		self.labelDate.clipsToBounds = true
		
		self.labelWebsite.font = self.setting.fontWebsite
		self.labelWebsite.textAlignment = .right
		self.labelWebsite.textColor = self.setting.colorWebsite
		self.labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		self.labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
		self.labelWebsite.backgroundColor = .white
		self.labelWebsite.clipsToBounds = true
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .bottom
		stackView.distribution = .fill
		stackView.spacing = 8
		
		stackView.addArrangedSubview(self.labelDate)
		stackView.addArrangedSubview(self.labelWebsite)
		
		return stackView
	}
	
    public init(setting: ALArticleTableViewCellSetting) {
		self.setting = setting
		
		super.init(style: .default, reuseIdentifier: self.reuseIdentifier)
		
		self.initView()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func initView() {
        self.imageViewThumbnail.contentMode = .center
        self.imageViewThumbnail.backgroundColor = .white
        self.imageViewThumbnail.clipsToBounds = true
        
		self.labelTitle.font = setting.fontTitle
		self.labelTitle.numberOfLines = 2
		self.labelTitle.textAlignment = .left
		self.labelTitle.textColor = self.setting.colorTitle
		self.labelTitle.backgroundColor = .white
		self.labelTitle.clipsToBounds = true
		
		self.stackViewRight.axis = .vertical
		self.stackViewRight.alignment = .fill
		self.stackViewRight.distribution = .equalSpacing
		
		self.stackViewRight.addArrangedSubview(self.labelTitle)
		self.stackViewRight.addArrangedSubview(self.stackViewBottom)
		
		self.contentView.addSubview(self.imageViewThumbnail)
		self.contentView.addSubview(self.stackViewRight)
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		if self.alArticle?.isRead == true {
			self.read()
        } else {
            self.unread()
        }
		
		self.layout()
	}
	
	func layout() {
		self.imageViewThumbnail.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: self.setting.sizeThumbnail.width, height: self.setting.sizeThumbnail.height), self.setting.paddingThumbnail)
		
		let widthRight = self.contentView.frame.width - self.setting.sizeThumbnail.width - self.setting.paddingContent.left - self.setting.paddingContent.right
		let heightRight = self.contentView.frame.height - self.setting.paddingContent.top - self.setting.paddingContent.bottom
		
		self.stackViewRight.frame = CGRect(x: self.setting.sizeThumbnail.width + self.setting.paddingContent.left, y: self.setting.paddingContent.top, width: widthRight, height: heightRight)
        
        let article = self.alArticle
        
        self.labelTitle.text = article?.title
        self.labelDate.text = article?.date
        self.labelWebsite.text = article?.website
        
        self.imageViewThumbnail.image = nil
        
        if let image = article?.imageThumbnail {
            self.imageViewThumbnail.image = image
        } else {
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.setting.sizeThumbnail.width - self.setting.paddingThumbnail.left - self.setting.paddingThumbnail.right, height: self.setting.sizeThumbnail.height - self.setting.paddingThumbnail.top - self.setting.paddingThumbnail.bottom), radius: self.setting.radiusThumbnail)
            
            article?.loadThumbnailImage(filter: filter, block: {image in
                if self.alArticle == article {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    
                    self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
                    self.imageViewThumbnail.image = image
                }
            })
        }
	}
	
	internal func set(alArticle: ALArticle) {
        self.alArticle = alArticle
	}
	
	internal func read() {
		self.labelTitle.textColor = self.setting.colorTitleRead
	}
	
	internal func unread() {
		self.labelTitle.textColor = self.setting.colorTitle
	}
}
