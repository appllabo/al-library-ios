import UIKit
import AlamofireImage

public class ALArticleTableViewCellSetting : NSObject {
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

public class ALArticleTableViewCell : UITableViewCell {
    private let setting: ALArticleTableViewCellSetting
    
    private var alArticleLayouted: ALArticle?
    public var alArticle: ALArticle?
    
    public init(setting: ALArticleTableViewCellSetting) {
        self.setting = setting
        
        super.init(style: .default, reuseIdentifier: self.setting.reuseIdentifier)
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
        self.textLabel?.text = alArticle.title
    }
    
    internal func read() {
    }
    
    internal func unread() {
    }
}
