import UIKit

class ALSloppySwipePageViewController: UIPageViewController {
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
	
	internal var contentViewControllers: [UIViewController]
	
	internal var scrollView: UIScrollView!
	internal var disableGesture: Bool = false
	internal var isMoving: Bool = false
	internal var isScrolling: Bool = false
	internal var isBack: Bool = false
	internal var index: Int = 0
	
	init(contentViewController: UIViewController, transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, isSloppySwipe: Bool, options: [UIPageViewController.OptionsKey : Any]? = nil) {
		self.isSloppySwipe = isSloppySwipe
		self.contentViewControllers = [contentViewController]
		
		super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
		
		self.dataSource = self
		self.delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.scrollView = self.view.subviews.compactMap { $0 as? UIScrollView }.first
		self.scrollView?.delegate = self
		
		self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
		self.panGestureRecognizer?.delegate = self
		
		self.addGesture()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if self.index == 0 {
			self.disableGesture = false
		} else {
			self.disableGesture = true
		}
	}
	
	func addGesture() {
		if self.isSloppySwipe == true {
			self.view.addGestureRecognizer(self.panGestureRecognizer!)
		}
	}
}

extension ALSloppySwipePageViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {		
		if otherGestureRecognizer.view == self.scrollView && self.disableGesture == false {
			return true
		} else {
			return false
		}
	}
}

extension ALSloppySwipePageViewController: UIScrollViewDelegate {
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.isScrolling = true
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if self.index == 0 {
			if scrollView.contentOffset.x < scrollView.bounds.size.width {
				self.isBack = true
			} else {
				self.disableGesture = true
			}
		}
		
		if self.isBack == true {
			scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
		}
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		self.isScrolling = false
		self.isBack = false
		
		if self.index == 0 {
			self.disableGesture = false
		}
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		self.isScrolling = false
		self.isBack = false
		
		if self.index == 0 {
			self.disableGesture = false
		}
	}
}

extension ALSloppySwipePageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let index = self.contentViewControllers.index(of: viewController) else {
			return nil
		}
		
		if index > 0 {
			return self.contentViewControllers[index - 1]
		} else {
			return nil
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let index = self.contentViewControllers.index(of: viewController) else {
			return nil
		}
		
		if index < self.contentViewControllers.count - 1 {
			return self.contentViewControllers[index + 1]
		} else {
			return nil
		}
	}
}

extension ALSloppySwipePageViewController: UIPageViewControllerDelegate {
	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		if self.index == 0 {
			self.disableGesture = true
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if completed == false {
			return
		}
		
		guard let first = pageViewController.viewControllers?.first, let index = self.contentViewControllers.index(of: first) else {
			return
		}
		
		self.index = index
		
		self.isScrolling = false
		
		if self.index > 0 {
			self.disableGesture = true
		} else {
			self.disableGesture = false
		}
	}
}
