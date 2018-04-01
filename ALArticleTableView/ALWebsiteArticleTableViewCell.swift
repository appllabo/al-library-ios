import UIKit
import AlamofireImage

public class ALWebsiteArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var radiusWebsiteImage = CGFloat(8.5)
	public var thumbnailWebsite = UIImage()
	
	public override init() {
		
	}
}

public class ALWebsiteArticleTableViewCell: ALArticleTableViewCell {
	public override var reuseIdentifier: String {
		return "ALWebsiteArticle"
	}
	
	public var settingWebsite: ALWebsiteArticleTableViewCellSetting {
		return self.setting as! ALWebsiteArticleTableViewCellSetting
	}
	
	internal let imageViewWebsite = UIImageView()
	
	public override var stackViewBottom: UIStackView {
		self.labelWebsite.font = self.settingWebsite.fontWebsite
		self.labelWebsite.textAlignment = .left
		self.labelWebsite.textColor = self.settingWebsite.colorWebsite
		self.labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		self.labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
		
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
	
	public init(setting: ALWebsiteArticleTableViewCellSetting, isRead: @escaping () -> Bool) {
		super.init(setting: setting, isRead: isRead)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layout() {
		super.layout()
		
        self.imageViewWebsite.image = self.settingWebsite.thumbnailWebsite
		self.imageViewWebsite.contentMode = .scaleAspectFill
        self.imageViewWebsite.heightAnchor.constraint(equalToConstant: self.settingWebsite.radiusWebsiteImage * 2.0).isActive = true
        self.imageViewWebsite.widthAnchor.constraint(equalToConstant: self.settingWebsite.radiusWebsiteImage * 2.0).isActive = true
		self.imageViewWebsite.clipsToBounds = true
		self.imageViewWebsite.layer.cornerRadius = self.settingWebsite.radiusWebsiteImage
        
	}
	
	internal override func set(article: ALArticle) {
		super.set(article: article)
		
		article.loadWebsiteImage(block: {image in
			self.imageViewWebsite.image = image
		})
	}
}
