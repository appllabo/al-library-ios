import UIKit
import AlamofireImage

public class ALWebsiteArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var radiusWebsiteImage = CGFloat(8.5)
	public var thumbnailWebsite = UIImage()
	
	public override init() {
		
	}
}

public class ALWebsiteArticleTableViewCell: ALArticleTableViewCell {
	internal let imageViewWebsite = UIImageView()
	
	public var settingWebsite: ALWebsiteArticleTableViewCellSetting {
		return self.setting as! ALWebsiteArticleTableViewCellSetting
	}
	
	public override var stackViewBottom: UIStackView {
		self.labelWebsite.text = self.article.website
		self.labelWebsite.font = self.settingWebsite.fontWebsite
		self.labelWebsite.textAlignment = .left
		self.labelWebsite.textColor = self.settingWebsite.colorWebsite
		self.labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		self.labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
		
		self.labelDate.text = self.article.date
		self.labelDate.font = self.settingWebsite.fontDate
		self.labelDate.textAlignment = .right
		self.labelDate.textColor = self.setting.colorDate
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.spacing = 4
		
		stackView.addArrangedSubview(self.imageViewWebsite)
		stackView.addArrangedSubview(self.labelWebsite)
		stackView.addArrangedSubview(self.labelDate)
		
		return stackView
	}
	
	public init(article: ALArticle, setting: ALWebsiteArticleTableViewCellSetting = ALWebsiteArticleTableViewCellSetting(), isRead: @escaping () -> Bool) {
		super.init(article: article, setting: setting, reuseIdentifier: "ALWebsiteArticleTableViewCell", isRead: isRead)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layout() {
		super.layout()
		
		self.imageViewWebsite.contentMode = .scaleAspectFill
		self.imageViewWebsite.clipsToBounds = true
		self.imageViewWebsite.layer.cornerRadius = self.settingWebsite.radiusWebsiteImage
		
		if let string = self.article.websiteImage, let url = URL(string: string) {		
			let imagePlaceholder = UIImage()
			let filterWebsiteImage = AspectScaledToFillSizeFilter(size: CGSize(width: self.settingWebsite.radiusWebsiteImage * 2, height: self.settingWebsite.radiusWebsiteImage * 2))
			self.imageViewWebsite.af_setImage(withURL: url, placeholderImage: imagePlaceholder, filter: filterWebsiteImage)
		} else {
			self.imageViewWebsite.image = self.settingWebsite.thumbnailWebsite
		}
	}
}
