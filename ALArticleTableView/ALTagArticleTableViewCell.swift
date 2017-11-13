import UIKit

public class ALTagArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public override init() {
		
	}
}

public class ALTagArticleTableViewCell: ALArticleTableViewCell {
	public var settingTag: ALTagArticleTableViewCellSetting {
		return self.setting as! ALTagArticleTableViewCellSetting
	}
	
	public override var stackViewBottom: UIStackView {
		let labelDate = UILabel()
		labelDate.text = self.article.date
		labelDate.font = self.settingTag.fontDate
		labelDate.textAlignment = .left
		labelDate.textColor = self.setting.colorDate
		
		let labelWebsite = UILabel()
		labelWebsite.text = self.article.website
		labelWebsite.font = self.settingTag.fontWebsite
		labelWebsite.textAlignment = .right
		labelWebsite.textColor = self.settingTag.colorWebsite
		labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
		
		let stackViewBottom = UIStackView()
		stackViewBottom.axis = .horizontal
		stackViewBottom.alignment = .bottom
		stackViewBottom.distribution = .fill
		stackViewBottom.spacing = 8
		
		stackViewBottom.addArrangedSubview(labelDate)
		stackViewBottom.addArrangedSubview(labelWebsite)
		
		return stackViewBottom
	}
	
	public init(article: ALArticle, setting: ALTagArticleTableViewCellSetting = ALTagArticleTableViewCellSetting()) {
		super.init(article: article, setting: setting, reuseIdentifier: "ALTagArticleTableViewCell")
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layout() {
		super.layout()
	}
}
