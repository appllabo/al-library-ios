import UIKit
import AlamofireImage

public class ALImageArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var paddingWebsite = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
	public var paddingTitle = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
	public var radiusWebsiteImage = CGFloat(18)
	public var colorBottom = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	
	public override init() {
		super.init()
		
		self.paddingImage = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		self.fontWebsite = UIFont.boldSystemFont(ofSize: 16)
		self.fontDate = UIFont.systemFont(ofSize: 14)
		self.colorBackground = UIColor.clear
		self.colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
		self.colorRead = UIColor(hex: 0x707070, alpha: 1.0)
		self.colorWebsite = UIColor(hex: 0x000000, alpha: 1.0)
	}
}

public class ALImageArticleTableViewCell: ALArticleTableViewCell {
	public var settingImage: ALImageArticleTableViewCellSetting {
		return self.setting as! ALImageArticleTableViewCellSetting
	}
	
	private let labelTitle = UILabel()
	private let imageViewWebsite = UIImageView()
	private let imageViewThumbnail = UIImageView()
	private let stackViewImage = UIStackView()
	
	public var stackViewTop: UIStackView {
		let stackViewWebsiteRight = UIStackView()
		stackViewWebsiteRight.axis = .vertical
		stackViewWebsiteRight.alignment = .leading
		stackViewWebsiteRight.distribution = .equalSpacing
		stackViewWebsiteRight.spacing = 2
		stackViewWebsiteRight.setContentHuggingPriority(0, for: .horizontal)
		
		let labelWebsite = UILabel()
		labelWebsite.font = self.setting.fontWebsite
		labelWebsite.textAlignment = .left
		labelWebsite.textColor = self.setting.colorWebsite
		labelWebsite.text = article.website
		
		let labelDate = UILabel()
		labelDate.font = self.setting.fontDate
		labelDate.textColor = self.settingImage.colorBottom
		labelDate.text = article.date
		
		stackViewWebsiteRight.addArrangedSubview(labelWebsite)
		stackViewWebsiteRight.addArrangedSubview(labelDate)
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.spacing = 8
		stackView.layoutMargins = self.settingImage.paddingWebsite
		stackView.isLayoutMarginsRelativeArrangement = true
		
		stackView.addArrangedSubview(self.imageViewWebsite)
		stackView.addArrangedSubview(stackViewWebsiteRight)
		
		stackView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 54)
		
		return stackView
	}
	
	public init(article: ALArticle, setting: ALImageArticleTableViewCellSetting) {
		super.init(article: article, setting: setting, reuseIdentifier: "ALImageArticleTableViewCell")
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func initContentView() {
		self.stackViewImage.layoutMargins = self.setting.paddingImage
		self.stackViewImage.isLayoutMarginsRelativeArrangement = true
		self.stackViewImage.addArrangedSubview(self.imageViewThumbnail)
		
		self.labelTitle.font = .boldSystemFont(ofSize: 20)
		self.labelTitle.numberOfLines = 2
		self.labelTitle.textAlignment = .left
		self.labelTitle.textColor = self.setting.colorTitle
		self.labelTitle.text = article.title
		
		self.contentView.addSubview(self.stackViewTop)
		self.contentView.addSubview(self.stackViewImage)
		self.contentView.addSubview(self.labelTitle)
		
		if self.article.isRead == true {
			self.read()
		}
	}
	
	override func layout() {
		let heightThumbnail = (self.contentView.frame.width - self.setting.paddingImage.left - self.setting.paddingImage.right) / 16 * 9
		
		//self.stackViewWebsite.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 54)
		self.stackViewImage.frame = CGRect(x: 0, y: 54, width: self.contentView.frame.width, height: heightThumbnail)
		
		let imagePlaceholder = UIImage()
		
		let filterWebsiteImage = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.settingImage.radiusWebsiteImage * 2, height: self.settingImage.radiusWebsiteImage * 2), radius: self.settingImage.radiusWebsiteImage)
		let urlWebsiteImage = URL(string: self.article.websiteImage)!
		self.imageViewWebsite.af_setImage(withURL: urlWebsiteImage, placeholderImage: imagePlaceholder, filter: filterWebsiteImage)
		
		let filterArticleImage = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.contentView.frame.width - 16, height: heightThumbnail), radius: 0.0)
		let urlArticleImage = URL(string: self.article.img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) ?? URL(string: "https://avatars2.githubusercontent.com/u/0")!
		self.imageViewThumbnail.af_setImage(withURL: urlArticleImage, placeholderImage: imagePlaceholder, filter: filterArticleImage)
		
		self.labelTitle.frame = CGRect(x: self.settingImage.paddingTitle.left, y: heightThumbnail + 54 + self.settingImage.paddingTitle.top, width: self.contentView.frame.width - self.settingImage.paddingTitle.left - self.settingImage.paddingTitle.right, height: 64 - self.settingImage.paddingTitle.top - self.settingImage.paddingTitle.bottom)
		
		self.setting.height = 54 + self.contentView.frame.width / 16 * 9 + 64
	}
}
