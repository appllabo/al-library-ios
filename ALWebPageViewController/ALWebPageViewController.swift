import WebKit

class ALWebPageViewController: ALSwipeTabContentViewController {
	fileprivate let webView = WKWebView()
	fileprivate let activityIndicator = UIActivityIndicatorView()
	
	init(title: String, url: String, isTabContent: Bool) {
		print("ALWebPageViewController:init")
		
		super.init(title: title, isTabContent: isTabContent)
		
		self.view.backgroundColor = DesignParameter.ViewBackgroundColor
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
		
		self.webView.navigationDelegate = self
//		self.webView.UIDelegate = self
		self.webView.scrollView.delegate = self
		self.webView.frame = self.view.bounds
		self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
		self.webView.backgroundColor = .clear
		self.webView.isOpaque = false
		self.view.addSubview(self.webView)
		
		let request: URLRequest = URLRequest(url: URL(string: url)!)
		self.webView.load(request)
		
		self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		self.activityIndicator.center = self.view.center
		self.activityIndicator.hidesWhenStopped = true
		self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
		self.activityIndicator.startAnimating()
//		self.webView.addSubview(self.activityIndicator)
		
		self.view.backgroundColor = DesignParameter.ViewBackgroundColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("WebPageViewController:deinit")
		
		self.webView.scrollView.delegate = nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.automaticallyAdjustsScrollViewInsets = true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if self.isTabContent == false {
			self.navigationController?.navigationBar.shadowImage = nil
			self.navigationController?.setToolbarHidden(true, animated: true)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	func didStartProvisionalNavigation(_ navigation: WKNavigation!) {
		print("didStartProvisionalNavigation")
	}
	
	func didFinish(_ navigation: WKNavigation!) {
		print("didFinish")
	}
	
	func evaluate(_ path: String) {
		print("evaluate")
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
		let urlRequest = navigationAction.request.url!.absoluteString
		
		if (urlRequest.hasPrefix("native://") == true) {
			let path = urlRequest.components(separatedBy: "native://")
			
			if (path[1] != "") {
				self.evaluate(path[1])
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
