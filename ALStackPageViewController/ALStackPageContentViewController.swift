import UIKit

class ALStackPageContentViewController: UIViewController {
	public var attributedTitleMain: NSMutableAttributedString {
		let paragraphStyle = NSMutableParagraphStyle().apply {
			$0.lineBreakMode = .byTruncatingTail
			$0.minimumLineHeight = CGFloat(22.0)
			$0.maximumLineHeight = CGFloat(22.0)
		}
		
		return NSMutableAttributedString(string: self.title ?? "Main").apply {
			$0.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, $0.length))
		}
	}
	
	public var attributedTitleSub: NSMutableAttributedString {
		let paragraphStyle = NSMutableParagraphStyle().apply {
			$0.lineBreakMode = .byTruncatingTail
			$0.minimumLineHeight = CGFloat(22.0)
			$0.maximumLineHeight = CGFloat(22.0)
		}
		
		return NSMutableAttributedString(string: self.title ?? "Sub").apply {
			$0.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, $0.length))
		}
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
