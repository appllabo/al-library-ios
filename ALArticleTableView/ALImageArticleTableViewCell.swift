import UIKit
import AlamofireImage

public class ALImageArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var paddingInfo = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
	public var paddingTitle = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
	public var radiusWebsiteImage = CGFloat(10)
	public var colorBottom = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	public var thumbnailWebsite = UIImage()
	
	public override init() {
		super.init()
		
        self.borderRadiusImage = CGFloat(4.0)
		self.paddingImage = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        self.fontTitle = .boldSystemFont(ofSize: 20)
		self.fontWebsite = .systemFont(ofSize: 14)
		self.fontDate = .systemFont(ofSize: 14)
		self.colorBackground = UIColor.clear
		self.colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
		self.colorRead = UIColor(hex: 0x707070, alpha: 1.0)
        self.colorWebsite = UIColor(hex: 0xa0a0a0, alpha: 1.0)
        self.colorDate = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	}
}

public class ALImageArticleTableViewCell: ALArticleTableViewCell {
	public override var reuseIdentifier: String {
		return "ALImageArticle"
	}
	
	public var settingImage: ALImageArticleTableViewCellSetting {
		return self.setting as! ALImageArticleTableViewCellSetting
	}
	
	internal let imageViewWebsite = UIImageView()
	internal let imageViewThumbnail = UIImageView()
	internal let stackViewInfo = UIStackView()
	
	public init(setting: ALImageArticleTableViewCellSetting, isRead: @escaping () -> Bool) {
		super.init(setting: setting, isRead: isRead)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func initView() {
		self.labelTitle.font = self.setting.fontTitle
		self.labelTitle.numberOfLines = 2
		self.labelTitle.textAlignment = .left
		self.labelTitle.textColor = self.setting.colorTitle
		
		self.initStackView(info: self.stackViewInfo)
		
        self.view.addSubview(self.labelTitle)
        self.view.addSubview(self.imageViewThumbnail)
		self.view.addSubview(self.stackViewInfo)
	}
	
	private func initStackView(info: UIStackView) {
        self.imageViewWebsite.setContentHuggingPriority(1, for: .horizontal)
        self.imageViewWebsite.setContentCompressionResistancePriority(1, for: .horizontal)
        
		self.labelWebsite.font = self.setting.fontWebsite
		self.labelWebsite.textAlignment = .left
		self.labelWebsite.textColor = self.setting.colorWebsite
		self.labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		self.labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
		
		self.labelDate.font = self.setting.fontDate
		self.labelDate.textAlignment = .right
		self.labelDate.textColor = self.setting.colorDate
        self.labelDate.setContentHuggingPriority(1, for: .horizontal)
		
		info.axis = .horizontal
		info.alignment = .center
		info.distribution = .fill
		info.spacing = 4
		
		info.addArrangedSubview(self.imageViewWebsite)
		info.addArrangedSubview(self.labelWebsite)
		info.addArrangedSubview(self.labelDate)
	}
	
	override func layout() {
        let widthThumbnail = self.view.frame.width - self.setting.paddingImage.left - self.setting.paddingImage.right
		let heightThumbnail = widthThumbnail / 16 * 9
		
		self.labelTitle.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64), self.settingImage.paddingTitle)
		self.imageViewThumbnail.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 64, width: self.view.frame.width, height: heightThumbnail), self.setting.paddingImage)
		self.stackViewInfo.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 64 + heightThumbnail, width: self.view.frame.width, height: 44), self.settingImage.paddingInfo)
		
		self.imageViewWebsite.image = self.settingImage.thumbnailWebsite
		self.imageViewWebsite.contentMode = .scaleAspectFill
		self.imageViewWebsite.clipsToBounds = true
		self.imageViewWebsite.layer.cornerRadius = self.settingImage.radiusWebsiteImage
		
		self.imageViewThumbnail.image = self.settingImage.thumbnail
		self.imageViewThumbnail.contentMode = .scaleAspectFill
		self.imageViewThumbnail.clipsToBounds = true
		self.imageViewThumbnail.layer.cornerRadius = self.settingImage.borderRadiusImage
		
		self.setting.height = 64 + widthThumbnail / 16 * 9 + 44
	}
	
	internal override func set(article: ALArticle) {
		super.set(article: article)
		
		article.loadImage(block: {image in
			self.imageViewThumbnail.image = image
			
			let transition = CATransition()
			transition.type = kCATransitionFade
			
			self.imageViewThumbnail.layer.add(transition, forKey: kCATransition)
		})
		
		article.loadWebsiteImage(block: {image in
			self.imageViewWebsite.image = image
		})
	}
}
