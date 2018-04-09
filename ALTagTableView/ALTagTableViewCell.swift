import UIKit
import AlamofireImage

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
        super.init(style: .value1, reuseIdentifier: "ALTag")
        
        if let url = tag.urlImage {
            let urlRequest = URLRequest(url: url)
            let filter = AspectScaledToFillSizeFilter(size: CGSize(width:20, height: 20))
            
            ImageDownloader.default.download(urlRequest, filter: filter) {[weak self] response in
                if let image = response.result.value {
                    self?.imageView?.image = image.withRenderingMode(.alwaysTemplate)
                }
            }
        }
        
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
