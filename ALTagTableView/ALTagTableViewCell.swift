import UIKit
import AlamofireImage

public class ALTagTableViewCellSetting : NSObject {
    public var reuseIdentifier: String {
        return "ALTag"
    }
    
    public var tintColor = UIColor.black
    public var sizeImage = CGSize(width: 29, height: 29)
    public var radiusImage = CGFloat(14.5)
    public var fontText = UIFont.systemFont(ofSize: 17)
    public var colorText = UIColor.black
}

class ALTagTableViewCell : UITableViewCell {
    private let data: ALTag
    private let setting: ALTagTableViewCellSetting
    
    init(tag: ALTag, setting: ALTagTableViewCellSetting) {
        self.data = tag
        self.setting = setting
        
        super.init(style: .value1, reuseIdentifier: "ALTag")
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layout()
    }
    
    public func initView() {
        self.imageView?.tintColor = setting.tintColor
        
        if let url = self.data.urlImage, self.imageView?.image == nil {
            let request = URLRequest(url: url)
            let filter = AspectScaledToFillSizeFilter(size: CGSize(width: 20, height: 20))

            ImageDownloader.default.download(request, filter: filter) { [weak self] response in
                if let image = response.result.value {
                    self?.imageView?.image = image.withRenderingMode(.alwaysTemplate)
                    
                    self?.setNeedsLayout()
                }
            }
        }
        
        self.textLabel?.run {
            $0.text = self.data.name
            $0.font = setting.fontText
            $0.textColor = setting.colorText
        }
        
        self.accessoryType = .disclosureIndicator
    }
    
    public func layout() {
    }
}
