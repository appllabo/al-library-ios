import UIKit
import SVGKit

public class ALTagArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var radiusTagImage = CGFloat(8.5)
	
	public override init() {
		
	}
}

public class ALTagArticleTableViewCell: ALArticleTableViewCell {
	public var settingTag: ALTagArticleTableViewCellSetting {
		return self.setting as! ALTagArticleTableViewCellSetting
	}
	
	public override var stackViewBottom: UIStackView {
		let imageViewTag = UIImageView()
		let image = SVGKImage(named: "Resource/Icon/tag-filled.svg")!
		image.size = CGSize(width: self.settingTag.radiusTagImage * 2, height: self.settingTag.radiusTagImage * 2)
		imageViewTag.image = image.uiImage.withRenderingMode(.alwaysTemplate)
		imageViewTag.tintColor = self.settingTag.tintColor
		
		let labelTag = UILabel()
		labelTag.text = self.article.stringTags
		labelTag.font = self.settingTag.fontWebsite
		labelTag.textAlignment = .left
		labelTag.textColor = self.settingTag.colorWebsite
		labelTag.setContentHuggingPriority(0, for: .horizontal)
		labelTag.setContentCompressionResistancePriority(0, for: .horizontal)
		
		let labelDate = UILabel()
		labelDate.text = self.article.date
		labelDate.font = self.settingTag.fontDate
		labelDate.textAlignment = .right
		labelDate.textColor = self.settingTag.colorDate
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .bottom
		stackView.distribution = .fill
		stackView.spacing = 4
		
		stackView.addArrangedSubview(imageViewTag)
		stackView.addArrangedSubview(labelTag)
		stackView.addArrangedSubview(labelDate)
		
		return stackView
	}
	
	public init(article: ALArticle, setting: ALTagArticleTableViewCellSetting = ALTagArticleTableViewCellSetting(), isRead: @escaping () -> Bool) {
		super.init(article: article, setting: setting, reuseIdentifier: "ALTagArticleTableViewCell", isRead: isRead)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layout() {
		super.layout()
	}
}
