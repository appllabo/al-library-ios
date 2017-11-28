import UIKit
import AlamofireImage

public class ALInstaArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var paddingInfo = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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

public class ALInstaArticleTableViewCell: ALArticleTableViewCell {
	public var settingImage: ALInstaArticleTableViewCellSetting {
		return self.setting as! ALInstaArticleTableViewCellSetting
	}
	
	private let labelTitle = UILabel()
	private let imageViewWebsite = UIImageView()
	private let imageViewThumbnail = UIImageView()
	private let stackViewInfo = UIStackView()
	
	public init(article: ALArticle, setting: ALImageArticleTableViewCellSetting, isRead: @escaping () -> Bool) {
		super.init(article: article, setting: setting, reuseIdentifier: "ALImageArticleTableViewCell", isRead: isRead)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func initView() {
		self.labelTitle.font = .boldSystemFont(ofSize: 20)
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
		
		info.axis = .horizontal
		info.alignment = .center
		info.distribution = .fill
		info.spacing = 8
		
		info.addArrangedSubview(self.imageViewWebsite)
		info.addArrangedSubview(stackViewWebsiteRight)
	}
	
	override func layout() {
		print("layout")
		
		let heightThumbnail = (self.view.frame.width - self.setting.paddingImage.left - self.setting.paddingImage.right) / 16 * 9
		
		self.labelTitle.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64), self.settingImage.paddingTitle)
		self.imageViewThumbnail.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: heightThumbnail)
		self.stackViewInfo.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 64 + heightThumbnail, width: self.view.frame.width, height: 54), self.settingImage.paddingInfo)
		
		let imagePlaceholder = UIImage()
		
		let filterWebsiteImage = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.settingImage.radiusWebsiteImage * 2, height: self.settingImage.radiusWebsiteImage * 2), radius: self.settingImage.radiusWebsiteImage)
		let urlWebsiteImage = URL(string: self.article.websiteImage)!
		self.imageViewWebsite.af_setImage(withURL: urlWebsiteImage, placeholderImage: imagePlaceholder, filter: filterWebsiteImage)
		
		let filterArticleImage = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.view.frame.width, height: heightThumbnail), radius: 0.0)
		let urlArticleImage = URL(string: self.article.img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) ?? URL(string: "https://avatars2.githubusercontent.com/u/0")!
		self.imageViewThumbnail.af_setImage(withURL: urlArticleImage, placeholderImage: imagePlaceholder, filter: filterArticleImage)
		
		self.setting.height = 54 + self.view.frame.width / 16 * 9 + 64
	}
}
