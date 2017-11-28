import UIKit
import AlamofireImage

public class ALWebsiteArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var radiusWebsiteImage = CGFloat(8.5)
	
	public override init() {
		
	}
}

public class ALWebsiteArticleTableViewCell: ALArticleTableViewCell {
	private let imageViewWebsite = UIImageView()
	
	public var settingWebsite: ALWebsiteArticleTableViewCellSetting {
		return self.setting as! ALWebsiteArticleTableViewCellSetting
	}
	
	public override var stackViewBottom: UIStackView {
		let labelWebsite = UILabel()
		labelWebsite.text = self.article.website
		labelWebsite.font = self.settingWebsite.fontWebsite
		labelWebsite.textAlignment = .left
		labelWebsite.textColor = self.settingWebsite.colorWebsite
		labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
		
		let labelDate = UILabel()
		labelDate.text = self.article.date
		labelDate.font = self.settingWebsite.fontDate
		labelDate.textAlignment = .right
		labelDate.textColor = self.setting.colorDate
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .bottom
		stackView.distribution = .fill
		stackView.spacing = 4
		
		stackView.addArrangedSubview(self.imageViewWebsite)
		stackView.addArrangedSubview(labelWebsite)
		stackView.addArrangedSubview(labelDate)
		
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
		
		let imagePlaceholder = UIImage()
		let filterWebsiteImage = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: self.settingWebsite.radiusWebsiteImage * 2, height: self.settingWebsite.radiusWebsiteImage * 2), radius: self.settingWebsite.radiusWebsiteImage)
		let urlWebsiteImage = URL(string: self.article.websiteImage)!
		self.imageViewWebsite.af_setImage(withURL: urlWebsiteImage, placeholderImage: imagePlaceholder, filter: filterWebsiteImage)
	}
}
