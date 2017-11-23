import UIKit

class ALNativeWebViewController: ALSwipeTabContentViewController {
	private let webView = UIWebView()
	
	init(title: String, isTabContent: Bool, url: URL, isSloppySwipe: Bool) {
		super.init(title: title, isTabContent: isTabContent, isSloppySwipe: isSloppySwipe)
		
		self.webView.frame = self.view.frame
		self.webView.delegate = self
//		self.webView.scrollView.contentInset.top = 64
//		self.webView.scrollView.contentInset.bottom = 49
//		self.webView.scrollView.scrollIndicatorInsets.top = 64
//		self.webView.scrollView.scrollIndicatorInsets.bottom = 49
		self.webView.backgroundColor = .clear
		self.webView.isOpaque = false
		
		if self.isTabContent == true {
			self.webView.scrollView.contentInset.bottom += 44
			self.webView.scrollView.scrollIndicatorInsets.bottom += 44
		}
		
		self.view.addSubview(self.webView)
		
		let request = URLRequest(url: url)
		self.webView.loadRequest(request)
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
		let urlRequest = request.url!.absoluteString
		
		print(urlRequest)
		
		if (urlRequest.hasPrefix("native://") == true) {
			let path = urlRequest.components(separatedBy: "native://")
			
			if (path[1] != "") {
				self.evaluate(path[1])
			}
			
			return false
		} else {
			return true
		}
	}
}
