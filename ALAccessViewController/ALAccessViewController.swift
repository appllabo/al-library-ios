import UIKit

class ALAccessViewController: UIViewController {
	private let webView = UIWebView()
	
	init(url: URL, referer: String) {
		print("ALAccessViewController:init")
		
		super.init(nibName: nil, bundle: nil)
		
		self.webView.delegate = self
		
		self.webView.loadRequest(NSMutableURLRequest(url: url).apply {
			$0.setValue(referer, forHTTPHeaderField: "Referer")
		} as URLRequest)
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
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        guard let string = request.url?.absoluteString else {
            return true
        }
		
		if string.hasPrefix("itms://") == true || string.hasPrefix("itmss://") == true || string.hasPrefix("itms-apps://") == true || string.hasPrefix("itms-appss://") == true || string.hasPrefix("itms-services://") == true {
			return false
		} else {
            return true
		}
	}
}
