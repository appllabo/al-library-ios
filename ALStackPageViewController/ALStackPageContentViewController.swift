import UIKit

class ALStackPageContentViewController: UIViewController {
	internal var contentInsetTop: CGFloat {
		return 0.0
	}
	
	internal var contentInsetBottom: CGFloat {
		return 0.0
	}
	
	internal var heightTabBar: CGFloat {
		var height = self.tabBarController?.tabBar.frame.size.height ?? 0
		
		if #available(iOS 11.0, *) {
			height = self.view.safeAreaInsets.bottom
		}
		
		return height
	}
	
	internal var safeAreaInsetsBottom: CGFloat {
		var bottom = CGFloat(0.0)
		
		if #available(iOS 11.0, *) {
			bottom = self.view.safeAreaInsets.bottom
		}
		
		return bottom
	}
	
	public var attributedTitleMain: NSMutableAttributedString {
		let attributedText = NSMutableAttributedString(string: self.title ?? "Main")
		let lineHeight = CGFloat(22.0)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .byTruncatingTail
		paragraphStyle.minimumLineHeight = lineHeight
		paragraphStyle.maximumLineHeight = lineHeight
		attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
		
		return attributedText
	}
	
	public var attributedTitleSub: NSMutableAttributedString {
		let attributedText = NSMutableAttributedString(string: self.title ?? "Sub")
		let lineHeight = CGFloat(22.0)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .byTruncatingTail
		paragraphStyle.minimumLineHeight = lineHeight
		paragraphStyle.maximumLineHeight = lineHeight
		attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
		
		return attributedText
	}
    
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
}
