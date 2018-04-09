import WebKit
import SwiftyJSON

class ALWebPageViewController: ALSwipeTabContentViewController {
	fileprivate let webView = WKWebView()
	fileprivate let activityIndicator = UIActivityIndicatorView()
	
	init(title: String, url: URL, isSwipeTab: Bool, isSloppySwipe: Bool) {
		super.init(title: title, isSwipeTab: isSwipeTab, isSloppySwipe: isSloppySwipe)
		
		self.webView.navigationDelegate = self
//		self.webView.UIDelegate = self
		self.webView.scrollView.delegate = self
		self.webView.frame = self.view.bounds
		self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
		self.webView.backgroundColor = .clear
		self.webView.isOpaque = false
		
		self.webView.addObserver(self, forKeyPath :"estimatedProgress", options: .new, context: nil)
		self.webView.addObserver(self, forKeyPath :"title", options: .new, context: nil)
		self.webView.addObserver(self, forKeyPath :"loading", options: .new, context: nil)
		self.webView.addObserver(self, forKeyPath :"canGoBack", options: .new, context: nil)
		self.webView.addObserver(self, forKeyPath :"canGoForward", options: .new, context: nil)
		
        let request = URLRequest(url: url)
        
        self.webView.load(request)
		
		self.view.addSubview(self.webView)
		
		self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		self.activityIndicator.center = self.view.center
		self.activityIndicator.hidesWhenStopped = true
		self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
		self.activityIndicator.startAnimating()
//		self.webView.addSubview(self.activityIndicator)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		self.webView.scrollView.delegate = nil
		
		self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
		self.webView.removeObserver(self, forKeyPath: "title")
		self.webView.removeObserver(self, forKeyPath: "loading")
		self.webView.removeObserver(self, forKeyPath: "canGoBack")
		self.webView.removeObserver(self, forKeyPath: "canGoForward")
	}
	
	override func viewDidLoad() {
		if #available(iOS 11.0, *) {
			self.webView.scrollView.contentInsetAdjustmentBehavior = .never
		}
		
		super.viewDidLoad()
		
		let heightStatusBar = UIApplication.shared.statusBarFrame.size.height
		let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 44
		
		self.webView.scrollView.contentInset.top = heightStatusBar + heightNavigationBar
		self.webView.scrollView.scrollIndicatorInsets.top = heightStatusBar + heightNavigationBar
		
        self.webView.scrollView.contentInset.top += self.contentInsetTop
        self.webView.scrollView.scrollIndicatorInsets.top += self.contentInsetTop
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
		if let url = navigationAction.request.url, url.absoluteString.hasPrefix("native://") == true {
            let path = url.absoluteString.components(separatedBy: "native://")
            
            if let param = path[1].removingPercentEncoding {
                let json = JSON(parseJSON: param)
                self.evaluate(json)
            } else {
                print(path[1])
            }
            
            decisionHandler(.cancel)
		} else {
			decisionHandler(.allow)
		}
	}
}

extension ALWebPageViewController: UIScrollViewDelegate {
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
	}
}
