import UIKit

class ALStackPageContentViewController: UIViewController {
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
