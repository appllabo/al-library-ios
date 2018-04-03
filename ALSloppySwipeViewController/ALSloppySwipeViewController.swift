import UIKit

class ALSloppySwipeViewController: UIViewController {
	var _percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition!
	var _panGestureRecognizer: UIPanGestureRecognizer!
	var isSloppySwipe: Bool
	
	internal var contentInsetTop: CGFloat {
		return 0.0
	}
	
	internal var contentInsetBottom: CGFloat {
		return 0.0
	}
	
	internal var heightTabBar: CGFloat {
		var height = self.tabBarController?.tabBar.frame.size.height ?? 0
		
		if #available(iOS 11.0, *) {
			height = self.view.safeAreaInsets.bottom
		}
		
		return height
	}
	
	internal var safeAreaInsetsBottom: CGFloat {
		var bottom = CGFloat(0.0)
		
		if #available(iOS 11.0, *) {
			bottom = self.view.safeAreaInsets.bottom
		}
		
		return bottom
	}
	
	override var percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition? {
		get {
			return self._percentDrivenInteractiveTransition
		}
		
		set(value) {
			self._percentDrivenInteractiveTransition = value
		}
	}
	
	override var panGestureRecognizer: UIPanGestureRecognizer? {
		get {
			return self._panGestureRecognizer
		}
		
		set(value) {
			self._panGestureRecognizer = value
		}
	}
	
	init(isSloppySwipe: Bool) {
		self.isSloppySwipe = isSloppySwipe
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
		addGesture()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	func addGesture() {
		if self.isSloppySwipe == true {
			self.view.addGestureRecognizer(self.panGestureRecognizer!)
		}
	}
	
	func removeGesture() {
		if self.isSloppySwipe == true {
			self.view.removeGestureRecognizer(self.panGestureRecognizer!)
		}
	}
}

extension UIViewController: UINavigationControllerDelegate {
	public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return ALPercentDrivenInteractiveTransition()
	}
	
	public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		navigationController.delegate = nil
		
		if self.panGestureRecognizer?.state == .began {
			self.percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
			self.percentDrivenInteractiveTransition?.completionCurve = .easeOut
		} else {
			self.percentDrivenInteractiveTransition = nil
		}
		
		return self.percentDrivenInteractiveTransition
	}
}

extension UIViewController {
	var percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition? {
		get {
			return nil
		}
		
		set(value) {
		}
	}
	
	var panGestureRecognizer: UIPanGestureRecognizer? {
		get {
			return nil
		}
		
		set(value) {
		}
	}
	
	/*
	var isSloppySwipe: Bool {
		get {
			return true
		}
		
		set(value) {
		}
	}
	*/
	
	func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
		let percent = max(panGesture.translation(in: view).x, 0) / self.view.frame.width
		
		switch panGesture.state {
		case .began:
			navigationController?.delegate = self
			_ = navigationController?.popViewController(animated: true)
			
		case .changed:
			if let percentDrivenInteractiveTransition = self.percentDrivenInteractiveTransition {
				percentDrivenInteractiveTransition.update(percent)
			}
			
			self.view.layer.shadowOpacity = Float((1.0 - percent) * 0.2)
			
		case .ended:
			let velocity = panGesture.velocity(in: view).x
			
			// Continue if drag more than 50% of screen width or velocity is higher than 1000
			if percent > 0.5 || velocity > 1000 {
				self.percentDrivenInteractiveTransition?.finish()
			} else {
				self.percentDrivenInteractiveTransition?.cancel()
			}
			
		case .cancelled, .failed:
			self.percentDrivenInteractiveTransition?.cancel()
			
		default:
			break
		}
	}
}
