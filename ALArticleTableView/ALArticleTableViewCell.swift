import UIKit
import AlamofireImage

public class ALArticleTableViewCellSetting {
	public var height = CGFloat(102.0)
	public var borderRadiusImage = CGFloat(4.0)
	public var paddingImage = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
	public var paddingContent = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 12)
	public var colorBackground = UIColor.clear
	public var colorTitle = UIColor(hex: 0x000000, alpha: 1.0)
	public var colorRead = UIColor(hex: 0x707070, alpha: 1.0)
	public var colorDate = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	public var colorWebsite = UIColor(hex: 0xa0a0a0, alpha: 1.0)
	public var fontTitle = UIFont.boldSystemFont(ofSize: 17)
	public var fontDate = UIFont.systemFont(ofSize: 12)
	public var fontWebsite = UIFont.systemFont(ofSize: 12)
	public var tintColor = UIColor.black
	public var thumbnail = UIImage()
	
	public init() {
	}
}

public class ALArticleTableViewCell: UITableViewCell {
	public override var reuseIdentifier: String {
		return "ALArticle"
	}
	
	public let setting: ALArticleTableViewCellSetting
	public var isLayouted = false
	
	internal let view = UIView()
	internal let thumbnailView = UIImageView()
	internal let labelTitle = UILabel()
    internal let labelDate = UILabel()
    internal let labelWebsite = UILabel()
	internal let stackViewRight = UIStackView()
	
	internal let isRead: () -> Bool
	
	public var stackViewBottom: UIStackView {
		self.labelDate.font = self.setting.fontDate
		self.labelDate.textAlignment = .left
		self.labelDate.textColor = self.setting.colorDate
		self.labelDate.backgroundColor = .white
		self.labelDate.clipsToBounds = true
		
		self.labelWebsite.font = self.setting.fontWebsite
		self.labelWebsite.textAlignment = .right
		self.labelWebsite.textColor = self.setting.colorWebsite
		self.labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		self.labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
		self.labelWebsite.backgroundColor = .white
		self.labelWebsite.clipsToBounds = true
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .bottom
		stackView.distribution = .fill
		stackView.spacing = 8
		
		stackView.addArrangedSubview(self.labelDate)
		stackView.addArrangedSubview(self.labelWebsite)
		
		return stackView
	}
	
	public init(setting: ALArticleTableViewCellSetting, isRead: @escaping () -> Bool) {
		self.setting = setting
		self.isRead = isRead
		
		super.init(style: .default, reuseIdentifier: self.reuseIdentifier)
		
		self.initView()
		self.contentView.addSubview(self.view)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func initView() {
		self.labelTitle.font = setting.fontTitle
		self.labelTitle.numberOfLines = 2
		self.labelTitle.textAlignment = .left
		self.labelTitle.textColor = self.setting.colorTitle
		self.labelTitle.backgroundColor = .white
		self.labelTitle.clipsToBounds = true
		
		self.stackViewRight.axis = .vertical
		self.stackViewRight.alignment = .fill
		self.stackViewRight.distribution = .equalSpacing
		
		self.stackViewRight.addArrangedSubview(self.labelTitle)
		self.stackViewRight.addArrangedSubview(self.stackViewBottom)
		
		self.view.addSubview(self.thumbnailView)
		self.view.addSubview(self.stackViewRight)
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		if self.isLayouted == true {
			return
		}
		
		self.isLayouted = true
		self.view.frame = self.contentView.frame
		
		if self.isRead() == true {
			self.read()
		}
		
		self.layout()
	}
	
	func layout() {
		let heightImage = self.view.frame.height
		let widthImage = heightImage
		
		self.thumbnailView.frame = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: widthImage, height: heightImage), self.setting.paddingImage)
		self.thumbnailView.contentMode = .scaleAspectFill
		self.thumbnailView.clipsToBounds = true
		self.thumbnailView.layer.cornerRadius = self.setting.borderRadiusImage
		
		let widthRight = self.view.frame.width - widthImage - self.setting.paddingContent.left - self.setting.paddingContent.right
		let heightRight = self.view.frame.height - self.setting.paddingContent.top - self.setting.paddingContent.bottom
		
		self.stackViewRight.frame = CGRect(x: widthImage + self.setting.paddingContent.left, y: self.setting.paddingContent.top, width: widthRight, height: heightRight)
	}
	
	internal func set(article: ALArticle) {
		self.labelTitle.text = article.title
		self.labelDate.text = article.date
		self.labelWebsite.text = article.website
		
		if article.isRead == true {
			self.read()
		} else {
			self.unread()
		}
		
		if let image = article.imageThumbnail {
			self.thumbnailView.image = image
		} else {
			self.thumbnailView.image = self.setting.thumbnail
			
			article.loadThumbnailImage(block: {image in
				self.thumbnailView.image = image
				
				let transition = CATransition()
				transition.type = kCATransitionFade
				
				self.thumbnailView.layer.add(transition, forKey: kCATransition)
			})
		}
	}
	
	internal func read() {
		self.labelTitle.textColor = self.setting.colorRead
	}
	
	internal func unread() {
		self.labelTitle.textColor = self.setting.colorTitle
	}
}
