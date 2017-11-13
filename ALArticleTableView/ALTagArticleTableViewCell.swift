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
		
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .bottom
		stackView.distribution = .fill
		stackView.spacing = 8
		
		stackView.addArrangedSubview(labelDate)
		stackView.addArrangedSubview(labelWebsite)
		
		return stackView
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
