import UIKit

class ALBarButtonItemBadge : NSObject {
	var label: UILabel?
	var value = ""
	var backgroundColor = UIColor.red
	var textColor = UIColor.white
	var font = UIFont.systemFont(ofSize: 12.0)
	var padding = CGFloat(6.0)
	var paddingX = CGFloat(6.0)
	var paddingY = CGFloat(6.0)
	var minSize = CGFloat(8.0)
	var originX = CGFloat(0.0)
	var originY = CGFloat(-4.0)
	var shouldHideAtZero = false
	var shouldAnimate = true
}

extension UIBarButtonItem {
	func reset(value: String, badge: ALBarButtonItemBadge) {
		badge.value = value
		
		badge.label?.removeFromSuperview()
		
		let label = UILabel(frame: CGRect(x: badge.originX, y: badge.originY, width: 20, height: 20)).apply {
			badge.label = $0
			
			$0.textAlignment = .center
		}
		
		if let customView = self.customView {
			badge.originX = customView.frame.size.width - label.frame.size.width / 2
			
			customView.clipsToBounds = false
			
			customView.addSubview(label)
		} else if let view = self.value(forKey: "view") as? UIView {
			badge.originX = view.frame.size.width - label.frame.size.width
			
			view.addSubview(label)
		}
		
		self.refreshBadge(badge: badge)
	}
	
	func set(value: String, badge: ALBarButtonItemBadge) {
		badge.value = value
		
		self.refreshBadge(badge: badge)
	}
	
	func refreshBadge(badge: ALBarButtonItemBadge) {
		guard let lable = badge.label else {
			return
		}
		
		lable.textColor = badge.textColor
		lable.backgroundColor = badge.backgroundColor
		lable.font = badge.font
		
		if badge.value == "" || (badge.value == "0" && badge.shouldHideAtZero) {
			lable.isHidden = true
		} else {
			lable.isHidden = false
			
			self.updateBadgeValue(badge: badge)
		}
	}
	
	func badgeExpectedSize(badge: ALBarButtonItemBadge) -> CGSize {
		// When the value changes the badge could need to get bigger
		// Calculate expected size to fit new value
		// Use an intermediate label to get expected size thanks to sizeToFit
		// We don't call sizeToFit on the true label to avoid bad display
		guard let frameLabel = duplicate(badge.label, badge: badge) else {
			return CGSize.zero
		}
	
		frameLabel.sizeToFit()	
			
		return frameLabel.frame.size
	}
	
	func updateBadgeFrame(badge: ALBarButtonItemBadge) {
		guard let label = badge.label else {
			return
		}
		
		let expectedLabelSize = self.badgeExpectedSize(badge: badge)
		
//		let minHeight = expectedLabelSize.height < badge.minSize ? badge.minSize : expectedLabelSize.height
//		
//		let minWidth = expectedLabelSize.width < minHeight ? minHeight : expectedLabelSize.width
//		
//		label.layer.masksToBounds = true
//		label.frame = CGRect(x: badge.originX, y: badge.originY, width: minWidth + badge.paddingX, height: minHeight + badge.paddingY)
//		label.layer.cornerRadius = (minHeight + badge.paddingY) / 2
		
		var minHeight = expectedLabelSize.height
		
		minHeight = (minHeight < badge.minSize) ? badge.minSize : expectedLabelSize.height
		
		var minWidth = expectedLabelSize.width
		
		minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width
		
		label.layer.masksToBounds = true
		label.frame = CGRect(x: badge.originX, y: badge.originY, width: minWidth + badge.padding, height: minHeight + badge.padding)
		label.layer.cornerRadius = (minHeight + badge.padding) / 2
	}
	
	func updateBadgeValue(badge: ALBarButtonItemBadge) {
		guard let label = badge.label else {
			return
		}
		
		if badge.shouldAnimate && label.text != badge.value {
			let animation = CABasicAnimation(keyPath: "transform.scale").apply {
				$0.fromValue = 1.5
				$0.toValue = 1
				$0.duration = 0.2
				$0.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1.0, 1.0)
			}
			
			label.layer.add(animation, forKey: "bounceAnimation")
		}
		
		label.text = badge.value
		
		if badge.shouldAnimate {
			UIView.animate(withDuration: 0.2, animations: {
				self.updateBadgeFrame(badge: badge)
			})
		} else {
			self.updateBadgeFrame(badge: badge)
		}
	}
	
	func duplicate(_ labelToCopy: UILabel?, badge: ALBarButtonItemBadge) -> UILabel? {
		guard let label = labelToCopy else {
			return nil
		}
		
		return UILabel(frame: label.frame).apply {
			$0.text = label.text
			$0.font = label.font
		}
	}
	
	func removeBadge(badge: ALBarButtonItemBadge) {
		UIView.animate(withDuration: 0.2, animations: {
			badge.label?.transform = CGAffineTransform(scaleX: 0, y: 0)
		}, completion: { _ in
			badge.label?.removeFromSuperview()
			
			badge.label = nil
		})
	}
	
	func set(backgroundColor: UIColor, badge: ALBarButtonItemBadge) {
		badge.backgroundColor = backgroundColor
		
		self.refreshBadge(badge: badge)
	}
	
	func set(textColor: UIColor, badge: ALBarButtonItemBadge) {
		badge.textColor = textColor
		
		self.refreshBadge(badge: badge)
	}
	
	func set(font: UIFont, badge: ALBarButtonItemBadge) {
		badge.font = font
		
		self.refreshBadge(badge: badge)
	}
	
	func set(padding: CGFloat, badge: ALBarButtonItemBadge) {
		badge.padding = padding
		
		self.refreshBadge(badge: badge)
	}
	
	func set(minSize: CGFloat, badge: ALBarButtonItemBadge) {
		badge.minSize = minSize
		
		self.refreshBadge(badge: badge)
	}
	
	func set(originX: CGFloat, badge: ALBarButtonItemBadge) {
		badge.originX = originX
		
		self.refreshBadge(badge: badge)
	}
	
	func set(originY: CGFloat, badge: ALBarButtonItemBadge) {
		badge.originY = originY
		
		self.refreshBadge(badge: badge)
	}
	
	func set(shouldHideAtZero: Bool, badge: ALBarButtonItemBadge) {
		badge.shouldHideAtZero = shouldHideAtZero
		
		self.refreshBadge(badge: badge)
	}
	
	func set(shouldAnimate: Bool, badge: ALBarButtonItemBadge) {
		badge.shouldAnimate = shouldAnimate
		
		self.refreshBadge(badge: badge)
	}
}
