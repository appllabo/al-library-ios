import UIKit

class ALScrollImageViewController: UIViewController, UIScrollViewDelegate {
	private let scrollView = UIScrollView()
	private let imageView = UIImageView(image: UIImage())
	
	var image: UIImage? {
		return self.imageView.image
	}
	
	init(url: URL) {
		super.init(nibName: nil, bundle: nil)
		
		self.view.backgroundColor = UIColor.black
		
		self.scrollView.run {
			$0.frame = self.view.frame
			$0.delegate = self
			$0.minimumZoomScale = 1.0
			$0.maximumZoomScale = 2.0
			$0.isScrollEnabled = true
			$0.showsHorizontalScrollIndicator = true
			$0.showsVerticalScrollIndicator = true
		}
		
		let singleTapGesture = UITapGestureRecognizer(target: self, action:#selector(singleTap(_:))).apply {
			$0.numberOfTapsRequired = 1
		}
		let doubleTapGesture = UITapGestureRecognizer(target: self, action:#selector(doubleTap(_:))).apply {
			$0.numberOfTapsRequired = 2
		}
		
		self.scrollView.isUserInteractionEnabled = true
		self.scrollView.addGestureRecognizer(singleTapGesture)
		self.scrollView.addGestureRecognizer(doubleTapGesture)
		
		self.view.addSubview(self.scrollView)
		
		self.setImage(url)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("PageInnerViewController:deinit")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func setImage(_ url: URL) {
		let activityIndicator = UIActivityIndicatorView().apply {
			$0.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
			$0.center = self.view.center
			$0.hidesWhenStopped = true
			$0.activityIndicatorViewStyle = .white
			$0.startAnimating()
		}
		
		self.view.addSubview(activityIndicator)
		
		let configuration = URLSessionConfiguration.default.apply {
			$0.requestCachePolicy = .returnCacheDataElseLoad
		}
		
		URLSession(configuration: configuration).dataTask(with: url, completionHandler: { data, response, error in
			DispatchQueue.main.async(execute: {
				activityIndicator.stopAnimating()
				
				if let error = error {
					print("failed get data")
					print(error)
					
					return
				}
				
				guard let data = data else {
					return
				}
				
				autoreleasepool {
					guard let image = UIImage.animatedImage(withAnimatedGIFData: data) else {
						print("failed create image")
						
						return
					}
					
					self.imageView.image = image
					
					let rateH = self.scrollView.frame.width / image.size.width
					let rateV = self.scrollView.frame.height / image.size.height
					
					let rate = min(rateH, rateV, 1)
					
					let width = image.size.width * rate
					let height = image.size.height * rate
					
					self.imageView.frame.size = CGSize(width: width, height: height)
					
					self.scrollView.contentSize = self.imageView.frame.size
					
					self.scrollView.addSubview(self.imageView)
					
					self.updateScrollInset()
				}
			})
		}).resume()
	}
	
	func updateScrollInset() {
		let top = max((self.scrollView.frame.height - self.imageView.frame.height) / 2, 0)
		let left = max((self.scrollView.frame.width - self.imageView.frame.width) / 2, 0)
		
		self.scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: 0, right: 0)
	}
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		self.updateScrollInset()
	}
	
	func singleTap(_ gesture: UITapGestureRecognizer) {
		self.scrollView.setZoomScale(1.0, animated: true)
		
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		self.navigationController?.setToolbarHidden(false, animated: true)
	}
	
	func doubleTap(_ gesture: UITapGestureRecognizer) {
		if self.scrollView.zoomScale < self.scrollView.maximumZoomScale {
			let center = gesture.location(in: gesture.view)
			
			let width = self.scrollView.frame.size.width / self.scrollView.maximumZoomScale
			let height = self.scrollView.frame.size.height / self.scrollView.maximumZoomScale
			
			let x = center.x - width / 2.0
			let y = center.y - height / 2.0
			
			let rect = CGRect(x: x, y: y, width: width, height: height)
			
			self.scrollView.zoom(to: rect, animated: true)
			
			self.navigationController?.setNavigationBarHidden(true, animated: true)
			self.navigationController?.setToolbarHidden(true, animated: true)
		} else {
			self.scrollView.setZoomScale(1.0, animated: true)
			
			self.navigationController?.setNavigationBarHidden(false, animated: true)
			self.navigationController?.setToolbarHidden(false, animated: true)
		}
	}
}
