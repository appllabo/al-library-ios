import UIKit
import SVGKit
import AlamofireImage

public class ALArticleImageTableViewCellSetting {
	public var paddingWebsite = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
	public var paddingImage = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
	public var paddingTitle = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
	public var colorBackground = UIColor.clear
	public var colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
	public var colorRead = UIColor(hex: 0x707070, alpha: 1.0)
	public var colorWebsite = UIColor(hex: 0x000000, alpha: 1.0)
	public var colorBottom = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	
	public init() {
		
	}
}

public class ALArticleImageTableViewCell: UITableViewCell {
	public let setting: ALArticleImageTableViewCellSetting
	
	private let labelTitle = UILabel()
	private let imageViewWebsite = UIImageView()
	private let imageViewThumbnail = UIImageView()
	private let stackViewWebsite = UIStackView()
	private let stackViewImage = UIStackView()
	private let stackViewTitle = UIStackView()
	private let stackViewButton = UIStackView()
	
	private let article: ALJsonArticle
	
	public init(article: ALJsonArticle, setting: ALArticleImageTableViewCellSetting) {
		self.article = article
		self.setting = setting
		
		super.init(style: .default, reuseIdentifier: "ALArticleImageTableViewCell")
		
		let labelWebsite = UILabel()
		labelWebsite.font = .boldSystemFont(ofSize: 12)
		labelWebsite.textAlignment = .left
		labelWebsite.textColor = self.setting.colorWebsite
		labelWebsite.text = article.website
		
		let labelDate = UILabel()
		labelDate.font = .systemFont(ofSize: 12)
		labelDate.textColor = self.setting.colorBottom
		labelDate.text = article.date
		
		let stackViewWebsiteRight = UIStackView()
		stackViewWebsiteRight.axis = .vertical
		stackViewWebsiteRight.alignment = .leading
		stackViewWebsiteRight.distribution = .equalSpacing
		stackViewWebsiteRight.spacing = 4
		stackViewWebsiteRight.setContentHuggingPriority(0, for: .horizontal)
		
		stackViewWebsiteRight.addArrangedSubview(labelWebsite)
		stackViewWebsiteRight.addArrangedSubview(labelDate)
		
		self.stackViewWebsite.axis = .horizontal
		self.stackViewWebsite.alignment = .center
		self.stackViewWebsite.distribution = .fill
		self.stackViewWebsite.spacing = 8
		self.stackViewWebsite.layoutMargins = self.setting.paddingWebsite
		self.stackViewWebsite.isLayoutMarginsRelativeArrangement = true
		
		self.stackViewWebsite.addArrangedSubview(self.imageViewWebsite)
		self.stackViewWebsite.addArrangedSubview(stackViewWebsiteRight)
		
		self.stackViewImage.layoutMargins = self.setting.paddingImage
		self.stackViewImage.isLayoutMarginsRelativeArrangement = true
		self.stackViewImage.addArrangedSubview(self.imageViewThumbnail)
		
		self.labelTitle.font = .boldSystemFont(ofSize: 20)
		self.labelTitle.numberOfLines = 2
		self.labelTitle.textAlignment = .left
		self.labelTitle.textColor = self.setting.colorTitle
		self.labelTitle.text = article.title
		
		self.stackViewTitle.axis = .vertical
		self.stackViewTitle.spacing = 8
		self.stackViewTitle.layoutMargins = self.setting.paddingTitle
		self.stackViewTitle.isLayoutMarginsRelativeArrangement = true
		
		self.stackViewTitle.addArrangedSubview(labelTitle)
		
		self.stackViewButton.axis = .horizontal
		self.stackViewButton.alignment = .top
		self.stackViewButton.distribution = .fill
		self.stackViewButton.spacing = 8
		
		let imageLike = SVGKImage(named: "Resource/Icon/like.svg")!
		let imageComment = SVGKImage(named: "Resource/Icon/speech-baloon.svg")!
		
		imageLike.size = CGSize(width: 24, height: 24)
		imageComment.size = CGSize(width: 24, height: 24)
		
		let imageViewLike = UIImageView()
		let imageViewComment = UIImageView()
		
		imageViewLike.image = imageLike.uiImage.withRenderingMode(.alwaysTemplate)
		imageViewComment.image = imageComment.uiImage.withRenderingMode(.alwaysTemplate)
		
		imageViewLike.tintColor = self.setting.colorBottom
		imageViewComment.tintColor = self.setting.colorBottom
		
		let labelEmpty = UILabel()
		labelEmpty.setContentHuggingPriority(0, for: .horizontal)
		labelEmpty.text = ""
		
		self.stackViewButton.addArrangedSubview(imageViewLike)
		self.stackViewButton.addArrangedSubview(imageViewComment)
		self.stackViewButton.addArrangedSubview(labelEmpty)
		
		self.stackViewTitle.addArrangedSubview(self.stackViewButton)
		
		self.contentView.addSubview(self.stackViewWebsite)
		self.contentView.addSubview(self.stackViewImage)
		self.contentView.addSubview(self.stackViewTitle)
		
		if (self.article.isRead == true) {
			self.read()
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		let heightThumbnail = (self.contentView.frame.width - 16) / 4 * 3
		
		self.stackViewWebsite.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 54)
		self.stackViewImage.frame = CGRect(x: 0, y: 54, width: self.contentView.frame.width, height: heightThumbnail)
		
		let imagePlaceholder = UIImage()
		
		let filterWebsiteImage = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: 29, height: 29), radius: 24.5)
		let urlWebsiteImage = URL(string: self.article.websiteImage)!
		self.imageViewWebsite.af_setImage(withURL: urlWebsiteImage, placeholderImage: imagePlaceholder, filter: filterWebsiteImage)
		
		let filterArticleImage = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.contentView.frame.width - 16, height: heightThumbnail), radius: 0.0)
		let urlArticleImage = URL(string: self.article.img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) ?? URL(string: "https://avatars2.githubusercontent.com/u/0")!
		self.imageViewThumbnail.af_setImage(withURL: urlArticleImage, placeholderImage: imagePlaceholder, filter: filterArticleImage)
		
		self.stackViewTitle.frame = CGRect(x: 0, y: heightThumbnail + 54, width: self.contentView.frame.width, height: 96)
	}
	
	internal func read() {
		self.self.labelTitle.textColor = self.setting.colorRead
	}
}
