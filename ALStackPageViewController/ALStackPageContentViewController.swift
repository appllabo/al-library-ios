import UIKit

class ALStackPageContentViewController : UIViewController {
	override var contentInsetTop: CGFloat {
		if #available(iOS 11.0, *) {
			return super.contentInsetTop
		} else {
			let heightStatusBar = UIApplication.shared.statusBarFrame.size.height
			let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 0
			
			return super.contentInsetTop + heightStatusBar + heightNavigationBar
		}
    }
    
	override var contentInsetBottom: CGFloat {
		if #available(iOS 11.0, *) {
			return super.contentInsetBottom
		} else {
			return super.contentInsetBottom + self.heightToolBar
		}
	}
	
	public var attributedTitleMain: NSMutableAttributedString {
		let paragraphStyle = NSMutableParagraphStyle().apply {
			$0.lineBreakMode = .byTruncatingTail
			$0.minimumLineHeight = CGFloat(22.0)
			$0.maximumLineHeight = CGFloat(22.0)
		}
		
		return NSMutableAttributedString(string: self.title ?? "Main").apply {
			$0.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, $0.length))
		}
	}
	
	public var attributedTitleSub: NSMutableAttributedString {
		let paragraphStyle = NSMutableParagraphStyle().apply {
			$0.lineBreakMode = .byTruncatingTail
			$0.minimumLineHeight = CGFloat(22.0)
			$0.maximumLineHeight = CGFloat(22.0)
		}
		
		return NSMutableAttributedString(string: self.title ?? "Sub").apply {
			$0.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, $0.length))
		}
	}
    
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
