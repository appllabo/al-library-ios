import UIKit
import SVGKit

public class ALTagTableViewCellSetting {
    public var tintColor = UIColor.black
    public var sizeImage = CGSize(width: 29, height: 29)
    public var radiusImage = CGFloat(14.5)
    public var fontText = UIFont.systemFont(ofSize: 17)
    public var fontDetailText = UIFont.systemFont(ofSize: 17)
    public var colorText = UIColor.black
    public var colorTextDetail = UIColor.black
    
    public init() {
        
    }
}

class ALTagTableViewCell: UITableViewCell {
    init(tag: ALTag, setting: ALTagTableViewCellSetting) {
        super.init(style: .value1, reuseIdentifier: "ALTagTableViewCell")
        
        let image = SVGKImage(named: "Resource/Icon/tag.svg")!
        image.size = CGSize(width: 20, height: 20)
        self.imageView?.image = image.uiImage.withRenderingMode(.alwaysTemplate)
        self.imageView?.tintColor = setting.tintColor
        
        self.textLabel?.text = tag.name
        self.textLabel?.font = setting.fontText
        self.textLabel?.textColor = setting.colorText
        
        self.detailTextLabel?.text = String(tag.contentUpdated)
        self.detailTextLabel?.textAlignment = .right
        self.detailTextLabel?.font = setting.fontDetailText
        self.detailTextLabel?.textColor = setting.colorTextDetail
        
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
