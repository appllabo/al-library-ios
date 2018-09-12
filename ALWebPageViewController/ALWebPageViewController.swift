import WebKit
import SwiftyJSON

class ALWebPageViewController: ALSwipeTabContentViewController {
	fileprivate let webView = WKWebView()
	fileprivate let activityIndicator = UIActivityIndicatorView()
	
	init(title: String, url: URL, isSwipeTab: Bool, isSloppySwipe: Bool) {
		super.init(title: title, isSwipeTab: isSwipeTab, isSloppySwipe: isSloppySwipe)
		
		self.webView.run {
			$0.navigationDelegate = self
	//		$0.UIDelegate = self
			$0.scrollView.delegate = self
			$0.frame = self.view.frame
			$0.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
			$0.backgroundColor = .clear
			$0.isOpaque = false
			
			$0.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
			$0.addObserver(self, forKeyPath: "title", options: .new, context: nil)
			$0.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
			$0.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
			$0.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
		}
        
        let request = URLRequest(url: url)
        
        self.webView.load(request)
        
        self.view.addSubview(self.webView)
		
		self.activityIndicator.run {
			$0.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
			$0.center = self.view.center
			$0.hidesWhenStopped = true
			$0.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
			$0.startAnimating()
		}
        
//        self.webView.addSubview(self.activityIndicator)
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
		if #available(iOS 11.0, *) {
			self.webView.scrollView.contentInsetAdjustmentBehavior = .never
		}
		
		super.viewDidLoad()
		
		self.webView.run {
            let heightStatusBar = UIApplication.shared.statusBarFrame.size.height
            let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 44
            
            $0.scrollView.contentInset.top = heightStatusBar + heightNavigationBar
            $0.scrollView.scrollIndicatorInsets.top = heightStatusBar + heightNavigationBar
            
            $0.scrollView.contentInset.top += self.contentInsetTop
            $0.scrollView.scrollIndicatorInsets.top += self.contentInsetTop
        }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if self.isSwipeTab == false {
			self.navigationController?.navigationBar.shadowImage = nil
			self.navigationController?.setToolbarHidden(true, animated: true)
		}
	}
	
	override func viewWillLayoutSubviews() {
		self.webView.frame = self.view.bounds
		
		var heightSafeArea = CGFloat(0.0)
		
		if #available(iOS 11.0, *) {
			heightSafeArea = self.view.safeAreaInsets.bottom
		}
		
		self.webView.scrollView.contentInset.bottom = heightSafeArea
		self.webView.scrollView.scrollIndicatorInsets.bottom = heightSafeArea
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
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

extension ALWebPageViewController: UIScrollViewDelegate {
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
	}
}
