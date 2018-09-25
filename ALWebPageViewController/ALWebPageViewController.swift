import WebKit
import SafariServices
import SwiftyJSON

class ALWebPageViewController : ALSwipeTabContentViewController {
	fileprivate let webView = WKWebView()
	
	init(title: String, url: URL, isSloppySwipe: Bool, swipeTabViewController: ALSwipeTabViewController? = nil) {
		super.init(title: title, isSloppySwipe: isSloppySwipe, swipeTabViewController: swipeTabViewController)
		
		self.webView.run {
			$0.uiDelegate = self
			$0.navigationDelegate = self
			$0.scrollView.delegate = self
			$0.scrollView.decelerationRate = .normal
			
			$0.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
			$0.addObserver(self, forKeyPath: "title", options: .new, context: nil)
			$0.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
			$0.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
			$0.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
		}
        
		self.view.addSubview(self.webView)
		
        let request = URLRequest(url: url)
        
        self.webView.load(request)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		self.webView.run {
			$0.scrollView.delegate = nil
			
			$0.removeObserver(self, forKeyPath: "estimatedProgress")
			$0.removeObserver(self, forKeyPath: "title")
			$0.removeObserver(self, forKeyPath: "loading")
			$0.removeObserver(self, forKeyPath: "canGoBack")
			$0.removeObserver(self, forKeyPath: "canGoForward")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.webView.run {
			$0.frame = self.view.bounds
			$0.backgroundColor = .clear
			$0.isOpaque = false
			
			$0.scrollView.contentInset.top = self.contentInsetTop
			$0.scrollView.scrollIndicatorInsets.top = self.contentInsetTop
        }
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		self.observeValue(self.webView, forKeyPath: keyPath)
	}
	
	func observeValue(_ webView: WKWebView, forKeyPath keyPath: String?) {
	}
	
	func didStartProvisionalNavigation(_ navigation: WKNavigation!) {
	}
	
	func didFinish(_ navigation: WKNavigation!) {
	}
	
	func evaluate(_ json: JSON) {
	}
}

extension ALWebPageViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		self.didStartProvisionalNavigation(navigation)
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		self.didFinish(navigation)
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (@escaping (WKNavigationActionPolicy) -> Void)) {
		guard let string = navigationAction.request.url?.absoluteString else {
			decisionHandler(.allow)
			
			return
		}
		
		if string.hasPrefix("native://") == false {
			decisionHandler(.allow)
			
			return
		}
	
		let path = string.components(separatedBy: "native://")
		
		guard let param = path[1].removingPercentEncoding else {
			decisionHandler(.allow)
			
			return
		}
		
		let json = JSON(parseJSON: param)
		
		self.evaluate(json)
		
		decisionHandler(.cancel)
	}
}

extension ALWebPageViewController : WKUIDelegate {
	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		guard let url = navigationAction.request.url else {
			return nil
		}
		
		if navigationAction.targetFrame == nil, UIApplication.shared.canOpenURL(url) == true {
			let viewController = SFSafariViewController(url: url, entersReaderIfAvailable: false).apply {
				$0.delegate = self
			}
			
			self.present(viewController, animated: true)
		}
		
		return nil
	}
}

extension ALWebPageViewController: SFSafariViewControllerDelegate {
	func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
	}
	
	func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
		return []
	}
	
	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
	}
}

extension ALWebPageViewController : UIScrollViewDelegate {
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.webView.scrollView.decelerationRate = .normal
	}
}
