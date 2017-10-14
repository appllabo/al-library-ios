import UIKit

class ALPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.5
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		/*
		let containerView = transitionContext.containerView
		let fromView = transitionContext.viewController(forKey: .from)!.view!
		let toView = transitionContext.viewController(forKey: .to)!.view!
		
		let width = containerView.frame.width
		
		var fromFrame = fromView.frame
		fromFrame.origin.x = width
		
		var toFrame = toView.frame
		toFrame.origin.x = -width / 3.33
		toView.frame = toFrame
		
		fromView.layer.shadowRadius = 5.0
		fromView.layer.shadowOpacity = 1.0
		toView.layer.opacity = 0.9
		
		containerView.insertSubview(toView, belowSubview: fromView)
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
			toView.frame = fromView.frame
			fromView.frame = fromFrame
			
			toView.layer.opacity = 1.0
			fromView.layer.shadowOpacity = 0.2
		}, completion: {finished in
			toView.layer.opacity = 1.0
			toView.layer.shadowOpacity = 0
			fromView.layer.opacity = 1.0
			fromView.layer.shadowOpacity = 0
			
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})*/
		guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
			return
		}
		
		let containerView = transitionContext.containerView
		let toView = toViewController.view!
		let fromView = fromViewController.view!
		
		containerView.insertSubview(toView, belowSubview: fromView)
		
		let colorView = UIView(frame: containerView.frame)
		colorView.backgroundColor = .black
		colorView.layer.opacity = 0.1
		containerView.insertSubview(colorView, aboveSubview: toView)
		
		let offset = -containerView.frame.width * 0.3
		
		fromView.frame = containerView.frame
		fromView.transform = .identity
		toView.frame = containerView.frame
		toView.transform = CGAffineTransform(translationX: offset, y: 0)
		
		fromView.layer.masksToBounds = false
		fromView.layer.shadowRadius = 3.0
		fromView.layer.shadowOffset = CGSize(width: -4.0, height: 0.0)
		fromView.layer.shadowOpacity = 0.2
		
		let aniDuration = transitionDuration(using: transitionContext)
		
		UIView.animate(withDuration: aniDuration, delay: 0, options: .curveLinear, animations: {
			fromView.transform = CGAffineTransform(translationX: containerView.frame.width, y: 0)
			toView.transform = .identity
			colorView.layer.opacity = 0.0
		}, completion: {finished in
			fromView.transform = .identity
			toView.transform = .identity
			
			colorView.removeFromSuperview()
			fromView.layer.shadowOpacity = 0
			
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
	}
}
