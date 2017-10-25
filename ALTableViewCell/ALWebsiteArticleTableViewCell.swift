import UIKit
import AlamofireImage

public class ALWebsiteArticleTableViewCellSetting {
	public var height = CGFloat(102.0)
	public var borderRadiusImage = CGFloat(4.0)
	public var paddingImage = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
	public var paddingContent = UIEdgeInsets(top: 12, left: 4, bottom: 12, right: 12)
	public var colorBackground = UIColor.clear
	public var colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
	public var colorRead = UIColor(hex: 0x707070, alpha: 1.0)
	public var colorDate = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	public var colorWebsite = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	public var fontTitle = UIFont.boldSystemFont(ofSize: 17)
	public var fontDate = UIFont.systemFont(ofSize: 12)
	public var fontWebsite = UIFont.systemFont(ofSize: 12)
	
	public init() {
		
	}
}

public class ALWebsiteArticleTableViewCell: UITableViewCell {
	public let setting: ALWebsiteArticleTableViewCellSetting
	public var isLayouted = false
	
	private let thumbnailView = UIImageView()
	private let titleLabel = UILabel()
	private let stackViewRight = UIStackView()
	
	private let article: ALJsonArticle
	
	public init(article: ALJsonArticle, setting: ALWebsiteArticleTableViewCellSetting = ALWebsiteArticleTableViewCellSetting()) {
		self.article = article
		self.setting = setting
		
		super.init(style: .default, reuseIdentifier: "ALWebsiteArticleTableViewCell")
		
		self.titleLabel.font = setting.fontTitle
		self.titleLabel.numberOfLines = 2
		self.titleLabel.textAlignment = .left
		self.titleLabel.textColor = self.setting.colorTitle
		self.titleLabel.text = article.title
		
		let labelDate = UILabel()
		labelDate.text = article.date
		labelDate.font = setting.fontDate
		labelDate.textAlignment = .left
		labelDate.textColor = self.setting.colorDate
		
		let labelWebsite = UILabel()
		labelWebsite.text = article.website
		labelWebsite.font = setting.fontWebsite
		labelWebsite.textAlignment = .right
		labelWebsite.textColor = self.setting.colorWebsite
		labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
		
		self.stackViewRight.axis = .vertical
		self.stackViewRight.alignment = .fill
		self.stackViewRight.distribution = .equalSpacing
		
		let stackViewBottom = UIStackView()
		stackViewBottom.axis = .horizontal
		stackViewBottom.alignment = .bottom
		stackViewBottom.distribution = .fill
		stackViewBottom.spacing = 8
		
		stackViewBottom.addArrangedSubview(labelDate)
		stackViewBottom.addArrangedSubview(labelWebsite)
		
		self.stackViewRight.addArrangedSubview(self.titleLabel)
		self.stackViewRight.addArrangedSubview(stackViewBottom)
		
		self.contentView.addSubview(self.thumbnailView)
		self.contentView.addSubview(self.stackViewRight)
		
		if self.article.isRead == true {
			self.read()
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		if self.isLayouted == true {
			return
		}
		
		self.layout()
	}
	
	func layout() {
		self.isLayouted = true
		
		let heightImage = self.contentView.frame.height
		let widthImage = heightImage
		
		self.thumbnailView.frame = CGRect(x: 0, y: 0, width: widthImage, height: heightImage)
		self.thumbnailView.contentMode = .center
		
		let heightThumbnail = heightImage - self.setting.paddingImage.top - self.setting.paddingImage.bottom
		let widthThumbnail = heightThumbnail
		
		let image = UIImage()
		let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: widthThumbnail, height: heightThumbnail), radius: self.setting.borderRadiusImage)
		let url = URL(string: self.article.img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) ?? URL(string: "https://avatars2.githubusercontent.com/u/0")!
		self.thumbnailView.af_setImage(withURL: url, placeholderImage: image, filter: filter)
		
		let widthRight = self.contentView.frame.width - widthImage - self.setting.paddingContent.left - self.setting.paddingContent.right
		let heightRight = self.contentView.frame.height - self.setting.paddingContent.top - self.setting.paddingContent.bottom
		
		self.stackViewRight.frame = CGRect(x: widthImage + self.setting.paddingContent.left, y: self.setting.paddingContent.top, width: widthRight, height: heightRight)
	}
	
	internal func read() {
		self.titleLabel.textColor = self.setting.colorRead
	}
}

