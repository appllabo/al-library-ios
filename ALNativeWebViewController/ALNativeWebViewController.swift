import UIKit
import WebKit

class ALNativeWebViewController : ALSwipeTabContentViewController {
    private let webView = WKWebView().apply {
        if #available(iOS 11.0, *) {
            $0.scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
	
	init(title: String, url: URL, isSloppySwipe: Bool, swipeTabViewController: ALSwipeTabViewController? = nil) {
		super.init(title: title, isSloppySwipe: isSloppySwipe, swipeTabViewController: swipeTabViewController)
		
		self.webView.run {
			$0.navigationDelegate = self
            $0.scrollView.delegate = self
			$0.scrollView.decelerationRate = .normal
            $0.allowsBackForwardNavigationGestures = false
		}
        
        self.view.addSubview(self.webView)
        
        let request = URLRequest(url: url)
        
        self.webView.load(request)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    deinit {
        self.webView.scrollView.delegate = nil
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.webView.run {
            $0.frame = self.view.bounds
            $0.isOpaque = false
			$0.backgroundColor = .clear
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.webView.run {
            $0.frame = self.view.bounds
			$0.scrollView.contentInset.top = self.contentInsetTop
			$0.scrollView.scrollIndicatorInsets.top = self.contentInsetTop
		}
	}
	
	func evaluate(_ path: String) {
		fatalError("evaluate(_ path:) has not been implemented")
	}
}

//extension ALNativeWebViewController : UIWebViewDelegate {
//	func webViewDidStartLoad(_ webView: UIWebView) {
//	}
//
//	func webViewDidFinishLoad(_ webView: UIWebView) {
//	}
//
//	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
//		guard let string = request.url?.absoluteString else {
//			return true
//		}
//
//		if !string.hasPrefix("native://") {
//			return true
//		}
//
//		let path = string.components(separatedBy: "native://")
//
//		if path.indices.contains(1) {
//			self.evaluate(path[1])
//		}
//
//		return false
//	}
//}

extension ALNativeWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (@escaping (WKNavigationActionPolicy) -> Void)) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            
            return
        }
        
        if !url.absoluteString.hasPrefix("native://") {
            decisionHandler(.allow)
            
            return
        }
        
        let path = url.absoluteString.components(separatedBy: "native://")
        
        if path.indices.contains(1) {
            self.evaluate(path[1])
        }
        
        decisionHandler(.cancel)
    }
}

extension ALNativeWebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.decelerationRate = .normal
    }
}
