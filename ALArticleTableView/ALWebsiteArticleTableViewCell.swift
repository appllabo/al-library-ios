import UIKit
import AlamofireImage

public class ALWebsiteArticleTableViewCellSetting : ALArticleTableViewCellSetting {
	public var radiusWebsiteImage = CGFloat(8.5)
	
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
        self.imageViewWebsite.contentMode = .center
        self.imageViewWebsite.heightAnchor.constraint(equalToConstant: self.settingWebsite.radiusWebsiteImage * 2.0).isActive = true
        self.imageViewWebsite.widthAnchor.constraint(equalToConstant: self.settingWebsite.radiusWebsiteImage * 2.0).isActive = true
        self.imageViewWebsite.clipsToBounds = true
        
		self.labelWebsite.font = self.settingWebsite.fontWebsite
		self.labelWebsite.textAlignment = .left
		self.labelWebsite.textColor = self.settingWebsite.colorWebsite
		self.labelWebsite.setContentHuggingPriority(0, for: .horizontal)
		self.labelWebsite.setContentCompressionResistancePriority(0, for: .horizontal)
        self.labelWebsite.backgroundColor = .white
        self.labelWebsite.clipsToBounds = true
		
		self.labelDate.font = self.settingWebsite.fontDate
		self.labelDate.textAlignment = .right
		self.labelDate.textColor = self.setting.colorDate
        self.labelDate.backgroundColor = .white
        self.labelDate.clipsToBounds = true
		
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
	
    override public func initView() {
        super.initView()
    }
    
	override func layout() {
		super.layout()
	}
	
	internal func set(article: Article) {
        super.set(alArticle: article)
		
        let filter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: self.settingWebsite.radiusWebsiteImage * 2.0, height: self.settingWebsite.radiusWebsiteImage * 2.0))
        
        if let image = article.imageWebsite {
            self.imageViewWebsite.image = image
        } else {
            self.imageViewWebsite.image = nil
            
            article.loadWebsiteImage(filter: filter, block: {image in
                self.imageViewWebsite.image = image
            })
        }
	}
}
