import UIKit
import AlamofireImage

public class ALInstaArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var paddingInfo = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
	public var paddingTitle = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
	public var radiusWebsiteImage = CGFloat(18)
	public var colorBottom = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	public var thumbnailWebsite = UIImage()
	
	public override init() {
		super.init()
		
		self.paddingImage = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.fontTitle = .boldSystemFont(ofSize: 20)
		self.fontWebsite = .boldSystemFont(ofSize: 16)
		self.fontDate = .systemFont(ofSize: 14)
		self.colorBackground = .clear
		self.colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
		self.colorRead = UIColor(hex: 0x707070, alpha: 1.0)
		self.colorWebsite = UIColor(hex: 0x000000, alpha: 1.0)
	}
}

public class ALInstaArticleTableViewCell: ALArticleTableViewCell {
	public var settingImage: ALInstaArticleTableViewCellSetting {
		return self.setting as! ALInstaArticleTableViewCellSetting
	}
	
	private let imageViewWebsite = UIImageView()
	private let imageViewThumbnail = UIImageView()
	private let stackViewInfo = UIStackView()
	
	public init(article: ALArticle, setting: ALInstaArticleTableViewCellSetting, isRead: @escaping () -> Bool) {
		super.init(article: article, setting: setting, reuseIdentifier: "ALInstaArticleTableViewCell", isRead: isRead)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func initView() {
		self.labelTitle.font = self.setting.fontTitle
		self.labelTitle.numberOfLines = 2
		self.labelTitle.textAlignment = .left
		self.labelTitle.textColor = self.setting.colorTitle
		self.labelTitle.text = article.title
		
		self.initStackView(info: self.stackViewInfo)
		
		self.view.addSubview(self.stackViewInfo)
		self.view.addSubview(self.imageViewThumbnail)
		self.view.addSubview(self.labelTitle)
		
		if self.article.isRead == true {
			self.read()
		}
	}
	
    private func initStackView(info: UIStackView) {
        self.labelWebsite.text = self.article.website
        self.labelWebsite.font = self.setting.fontWebsite
        self.labelWebsite.textAlignment = .left
        self.labelWebsite.textColor = self.setting.colorWebsite
        self.labelWebsite.setContentHuggingPriority(0, for: .horizontal)
        self.labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
        
        self.labelDate.text = self.article.date
        self.labelDate.font = self.setting.fontDate
        self.labelDate.textAlignment = .right
        self.labelDate.textColor = self.setting.colorDate
        
        info.axis = .horizontal
        info.alignment = .center
        info.distribution = .fill
        info.spacing = 8
        
        info.addArrangedSubview(self.imageViewWebsite)
        info.addArrangedSubview(self.labelWebsite)
        info.addArrangedSubview(self.labelDate)
    }
    
	override func layout() {
		let widthThumbnail = self.view.frame.width - self.setting.paddingImage.left - self.setting.paddingImage.right
		let heightThumbnail = widthThumbnail / 16 * 9
		
        self.stackViewInfo.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 54), self.settingImage.paddingInfo)
		self.imageViewThumbnail.frame = CGRect(x: 0, y: 54, width: self.view.frame.width, height: heightThumbnail)
        self.labelTitle.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 54 + heightThumbnail, width: self.view.frame.width, height: 64), self.settingImage.paddingTitle)
		
		self.imageViewWebsite.contentMode = .scaleAspectFill
		self.imageViewWebsite.clipsToBounds = true
		self.imageViewWebsite.layer.cornerRadius = self.settingImage.radiusWebsiteImage
		
		if let string = self.article.websiteImage, let url = URL(string: string) {		
			let imagePlaceholder = UIImage()
			let filterWebsiteImage = AspectScaledToFillSizeFilter(size: CGSize(width: self.settingImage.radiusWebsiteImage * 2, height: self.settingImage.radiusWebsiteImage * 2))
			self.imageViewWebsite.af_setImage(withURL: url, placeholderImage: imagePlaceholder, filter: filterWebsiteImage)
		} else {
			self.imageViewWebsite.image = self.settingImage.thumbnailWebsite
		}
		
		self.imageViewThumbnail.contentMode = .scaleAspectFill
		
		if let string = self.article.img, let url = URL(string: string) {
			let imagePlaceholder = UIImage()
			let filterArticleImage = AspectScaledToFillSizeFilter(size: CGSize(width: widthThumbnail, height: heightThumbnail))
			self.imageViewThumbnail.af_setImage(withURL: url, placeholderImage: imagePlaceholder, filter: filterArticleImage)
		} else {
			self.imageViewThumbnail.image = self.settingImage.thumbnail
		}
		
		self.setting.height = 54 + self.view.frame.width / 16 * 9 + 64
	}
}
