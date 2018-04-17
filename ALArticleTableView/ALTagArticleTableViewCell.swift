import UIKit
import AlamofireImage

public class ALTagArticleTableViewCellSetting : ALArticleTableViewCellSetting {
    public override var reuseIdentifier: String {
        return "ALTagArticle"
    }
    
    public override var separatorInset: UIEdgeInsets? {
        return UIEdgeInsets(top: 0, left: self.paddingThumbnail.left, bottom: 0, right: 0)
    }
    
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
	public var radiusTagImage = CGFloat(8.5)
    
    override func height(width: CGFloat) -> CGFloat {
        return sizeThumbnail.height
    }
}

public class ALTagArticleTableViewCell: ALArticleTableViewCell {
	private let setting: ALTagArticleTableViewCellSetting
	
    private let imageViewThumbnail = UIImageView()
    private let labelTitle = UILabel()
    private let labelDate = UILabel()
	private let imageViewTag = UIImageView()
	private let labelTag = UILabel()
    private let stackViewRight = UIStackView()
	
	private var stackViewBottom: UIStackView {
		self.imageViewTag.tintColor = self.setting.tintColor
        self.imageViewTag.heightAnchor.constraint(equalToConstant: self.setting.radiusTagImage * 2.0).isActive = true
        self.imageViewTag.widthAnchor.constraint(equalToConstant: self.setting.radiusTagImage * 2.0).isActive = true
        self.imageViewTag.clipsToBounds = true
		
		self.labelTag.font = self.setting.fontWebsite
		self.labelTag.textAlignment = .left
		self.labelTag.textColor = self.setting.colorWebsite
		self.labelTag.setContentHuggingPriority(0, for: .horizontal)
		self.labelTag.setContentCompressionResistancePriority(0, for: .horizontal)
        self.labelTag.backgroundColor = .white
        self.labelTag.clipsToBounds = true
		
		self.labelDate.font = self.setting.fontDate
		self.labelDate.textAlignment = .right
		self.labelDate.textColor = self.setting.colorDate
        self.labelDate.backgroundColor = .white
        self.labelDate.clipsToBounds = true
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .bottom
		stackView.distribution = .fill
		stackView.spacing = 4
		
		stackView.addArrangedSubview(self.imageViewTag)
		stackView.addArrangedSubview(self.labelTag)
		stackView.addArrangedSubview(self.labelDate)
		
		return stackView
	}
	
	public init(setting: ALTagArticleTableViewCellSetting) {
        self.setting = setting
        
		super.init(setting: setting)
        
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
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func layout(alArticle: ALArticle) {
        self.labelTitle.text = alArticle.title
        self.labelTag.text = alArticle.stringTags
        self.labelDate.text = alArticle.date
        
        self.imageViewThumbnail.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: self.setting.sizeThumbnail.width, height: self.setting.sizeThumbnail.height), self.setting.paddingThumbnail)
        
        let widthRight = self.contentView.frame.width - self.setting.sizeThumbnail.width - self.setting.paddingContent.left - self.setting.paddingContent.right
        let heightRight = self.contentView.frame.height - self.setting.paddingContent.top - self.setting.paddingContent.bottom
        
        self.stackViewRight.frame = CGRect(x: self.setting.sizeThumbnail.width + self.setting.paddingContent.left, y: self.setting.paddingContent.top, width: widthRight, height: heightRight)
        
        self.imageViewThumbnail.image = nil
        
        if let image = alArticle.imageThumbnail {
            self.imageViewThumbnail.image = image
        } else {
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.setting.sizeThumbnail.width - self.setting.paddingThumbnail.left - self.setting.paddingThumbnail.right, height: self.setting.sizeThumbnail.height - self.setting.paddingThumbnail.top - self.setting.paddingThumbnail.bottom), radius: self.setting.radiusThumbnail)
            
            alArticle.loadThumbnailImage(filter: filter, block: {image in
                if self.alArticle == alArticle {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    
                    self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
                    self.imageViewThumbnail.image = image
                }
            })
        }
        
        self.imageViewTag.image = nil
        
        if let image = alArticle.imageWebsite {
            self.imageViewTag.image = image
        } else {
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.setting.radiusTagImage * 2.0, height: self.setting.radiusTagImage * 2.0), radius: 0.0)
            
            alArticle.loadTagImage(filter: filter, block: {image in
                if self.alArticle == alArticle {
                    self.imageViewTag.image = image.withRenderingMode(.alwaysTemplate)
                }
            })
        }
    }
}
