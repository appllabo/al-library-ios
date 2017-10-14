import UIKit

class ALTagCollectionViewCell: UICollectionViewCell {
	internal let textLabel = UILabel()
	private let button = UIButton()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.button.setTitle("button", for: .normal)
		self.button.frame = CGRect(x:0, y:0, width: frame.width, height: frame.height)
		self.button.layer.borderColor = DesignParameter.TintColor.cgColor
		self.button.layer.cornerRadius = 3
		self.button.layer.borderWidth = 1.0
		self.button.clipsToBounds = true
		
		self.textLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
		self.textLabel.text = ""
		self.textLabel.backgroundColor = UIColor.white
		self.textLabel.textAlignment = NSTextAlignment.center
		self.textLabel.layer.borderColor = DesignParameter.TintColor.cgColor
		self.textLabel.layer.cornerRadius = 3
		self.textLabel.layer.borderWidth = 1.0
		self.textLabel.clipsToBounds = true
		
		self.contentView.addSubview(self.textLabel)
//		self.contentView.addSubview(self.button)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
