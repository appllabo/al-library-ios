import UIKit

class ALNativeWebViewController: ALSwipeTabContentViewController {
	private let webView = UIWebView()
	
	init(title: String, isSwipeTab: Bool, url: URL, isSloppySwipe: Bool) {
		super.init(title: title, isSwipeTab: isSwipeTab, isSloppySwipe: isSloppySwipe)
		
		self.webView.run {
			$0.frame = self.view.frame
			$0.delegate = self
			$0.backgroundColor = .clear
			$0.isOpaque = false
		
			if self.isSwipeTab == true {
				$0.scrollView.contentInset.bottom += 44
				$0.scrollView.scrollIndicatorInsets.bottom += 44
			}
		
			self.view.addSubview($0)
			
			let request = URLRequest(url: url)
			
			$0.loadRequest(request)
		}
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
	
	func evaluate(_ path: String) {
		fatalError("evaluate(_ path:) has not been implemented")
	}
}

extension ALNativeWebViewController: UIWebViewDelegate {
	func webViewDidStartLoad(_ webView: UIWebView) {
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
	}
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		guard let string = request.url?.absoluteString else {
			return true
		}
		
		if string.hasPrefix("native://") == false {
			return true
		}
		
		let path = string.components(separatedBy: "native://")
		
		if path[1] == "" {
			return true
		}
		
		self.evaluate(path[1])
		
		return false
	}
}
