import UIKit
import AlamofireImage

public class ALArticleTableViewCellSetting {
    public var reuseIdentifier: String {
        return "ALArticle"
    }
    
    public var separatorInset: UIEdgeInsets? {
        return nil
    }
    
    func height(width: CGFloat) -> CGFloat {
        return 44.0
    }
}

public class ALArticleTableViewCell: UITableViewCell {
    public let settingBase: ALArticleTableViewCellSetting
    
    public var alArticle: ALArticle?
    private var alArticleLayouted: ALArticle?
    
    public init(setting: ALArticleTableViewCellSetting) {
        self.settingBase = setting
        
        super.init(style: .default, reuseIdentifier: self.settingBase.reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.alArticle?.isRead == true {
            self.read()
        } else {
            self.unread()
        }
        
        guard let article = self.alArticle else {
            return
        }
        
        if article == self.alArticleLayouted {
            return
        }
        
        self.alArticleLayouted = article
        
        self.layout(alArticle: article)
    }
    
    internal func layout(alArticle: ALArticle) {
    }
    
    internal func read() {
        
    }
    
    internal func unread() {
        
    }
}
