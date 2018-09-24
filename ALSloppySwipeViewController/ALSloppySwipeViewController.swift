import UIKit

class ALSloppySwipeViewController: UIViewController {
	var _percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition!
	var _panGestureRecognizer: UIPanGestureRecognizer!
	var isSloppySwipe: Bool
	
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
		
		self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
		
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
	public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
