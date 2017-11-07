import UIKit

class ALAccessViewController: UIViewController {
	private let webView = UIWebView()
	
	init(url: String, referer: String) {
		print("ALAccessViewController:init")
		
		super.init(nibName: nil, bundle: nil)
		
		self.webView.delegate = self
		
		let url = URL(string: url)!
		let request = NSMutableURLRequest(url: url)
		request.setValue(referer, forHTTPHeaderField: "Referer")
		self.webView.loadRequest(request as URLRequest)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("ALAccessViewController:deinit")
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

extension ALAccessViewController: UIWebViewDelegate {
	func webViewDidStartLoad(_ webView: UIWebView) {
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
	}
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let urlRequest = request.url!.absoluteString
		
		if urlRequest.hasPrefix("itms://") == true || urlRequest.hasPrefix("itmss://") == true || urlRequest.hasPrefix("itms-apps://") == true || urlRequest.hasPrefix("itms-appss://") == true || urlRequest.hasPrefix("itms-services://") == true {
			return false
		} else {
			return true
		}
	}
}
