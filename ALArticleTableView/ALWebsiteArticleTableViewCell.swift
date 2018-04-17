import UIKit
import AlamofireImage

public class ALWebsiteArticleTableViewCellSetting : ALArticleTableViewCellSetting {
    public override var reuseIdentifier: String {
        return "ALWebsiteArticle"
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
	public var radiusWebsiteImage = CGFloat(8.5)
	
    override func height(width: CGFloat) -> CGFloat {
        return sizeThumbnail.height
    }
}

public class ALWebsiteArticleTableViewCell: ALArticleTableViewCell {
    private let setting: ALWebsiteArticleTableViewCellSetting
    
    private let imageViewThumbnail: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .center
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        
        return imageView
    } ()
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.textAlignment = .left
        label.backgroundColor = .white
        label.clipsToBounds = true
        
        return label
    } ()
    
    private let labelDate: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.backgroundColor = .white
        label.clipsToBounds = true
        
        return label
    } ()
    
    private let labelWebsite: UILabel = {
        let label = UILabel()
    
        label.textAlignment = .left
        label.setContentHuggingPriority(0, for: .horizontal)
        label.setContentCompressionResistancePriority(0, for: .horizontal)
        label.backgroundColor = .white
        label.clipsToBounds = true
        
        return label
    } ()
    
    private let imageViewWebsite: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .center
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        
        return imageView
    } ()
    
    private let stackViewBottom: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        
        return stackView
    } ()
    
    private let stackViewRight: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        return stackView
    } ()
	
	public init(setting: ALWebsiteArticleTableViewCellSetting) {
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
        self.imageViewThumbnail.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: self.setting.sizeThumbnail.width, height: self.setting.sizeThumbnail.height), self.setting.paddingThumbnail)
        
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
            
            alArticle.loadThumbnailImage(filter: filter, block: {image in
                if self.alArticle == alArticle {
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
            let filter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: self.setting.radiusWebsiteImage * 2.0, height: self.setting.radiusWebsiteImage * 2.0))
            
            self.alArticle?.loadWebsiteImage(filter: filter, block: {image in
                if self.alArticle == alArticle {
                    let transition = CATransition()
                    transition.type = kCATransitionFade
                    
                    self.imageViewWebsite.layer.add(transition, forKey: kCATransition)
                    self.imageViewWebsite.image = image
                }
            })
        }
    }
}
