import UIKit
import SVGKit

public class ALTagArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var radiusTagImage = CGFloat(8.5)
	
	public override init() {
		
	}
}

public class ALTagArticleTableViewCell: ALArticleTableViewCell {
	public override var reuseIdentifier: String {
		return "ALTagArticle"
	}
	
	public var settingTag: ALTagArticleTableViewCellSetting {
		return self.setting as! ALTagArticleTableViewCellSetting
	}
	
	private let imageViewTag = UIImageView()
	private let labelTag = UILabel()
	
	public override var stackViewBottom: UIStackView {
		let image = SVGKImage(named: "Resource/Icon/tag-filled.svg")!
		image.size = CGSize(width: self.settingTag.radiusTagImage * 2, height: self.settingTag.radiusTagImage * 2)
		
		self.imageViewTag.image = image.uiImage.withRenderingMode(.alwaysTemplate)
		self.imageViewTag.tintColor = self.settingTag.tintColor
		
		self.labelTag.font = self.settingTag.fontWebsite
		self.labelTag.textAlignment = .left
		self.labelTag.textColor = self.settingTag.colorWebsite
		self.labelTag.setContentHuggingPriority(0, for: .horizontal)
		self.labelTag.setContentCompressionResistancePriority(0, for: .horizontal)
        self.labelTag.backgroundColor = .white
        self.labelTag.clipsToBounds = true
		
		self.labelDate.font = self.settingTag.fontDate
		self.labelDate.textAlignment = .right
		self.labelDate.textColor = self.settingTag.colorDate
        self.labelDate.backgroundColor = .white
        self.labelDate.clipsToBounds = true
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .bottom
		stackView.distribution = .fill
		stackView.spacing = 4
		
		stackView.addArrangedSubview(self.imageViewTag)
		stackView.addArrangedSubview(self.labelTag)
		stackView.addArrangedSubview(self.labelDate)
		
		return stackView
	}
	
	public init(setting: ALTagArticleTableViewCellSetting, isRead: @escaping () -> Bool) {
		super.init(setting: setting, isRead: isRead)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layout() {
		super.layout()
	}
	
	internal func set(article: ALArticle) {
		super.set(alArticle: article)
		
		self.labelTag.text = article.stringTags
		self.labelDate.text = article.date
	}
}
