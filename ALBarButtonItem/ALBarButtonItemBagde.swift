import UIKit

class ALBarButtonItemBagde : NSObject {
	var label: UILabel?
	var value = ""
	var backgroundColor = UIColor.red
	var textColor = UIColor.white
	var font = UIFont.systemFont(ofSize: 12.0)
	var padding = CGFloat(6.0)
	var minSize = CGFloat(8.0)
	var originX = CGFloat(0.0)
	var originY = CGFloat(-4.0)
	var paddingX = CGFloat(0.0)
	var paddingY = CGFloat(0.0)
	var shouldHideAtZero = false
	var shouldAnimate = true
}

extension UIBarButtonItem {
	func reset(value: String, bagde: ALBarButtonItemBagde) {
		bagde.value = value
		
		bagde.label?.removeFromSuperview()
		
		let label = UILabel(frame: CGRect(x: bagde.originX, y: bagde.originY, width: 20, height: 20)).apply {
			bagde.label = $0
			
			$0.textAlignment = .center
		}
		
		if let customView = self.customView {
			bagde.originX = customView.frame.size.width - label.frame.size.width / 2
			
			customView.clipsToBounds = false
			
			customView.addSubview(label)
		} else if let view = self.value(forKey: "view") as? UIView {
			bagde.originX = view.frame.size.width - label.frame.size.width
			
			view.addSubview(label)
		}
		
		self.refreshBadge(bagde: bagde)
	}
	
	func set(value: String, bagde: ALBarButtonItemBagde) {
		bagde.value = value
		
		self.refreshBadge(bagde: bagde)
	}
	
	func refreshBadge(bagde: ALBarButtonItemBagde) {
		guard let lable = bagde.label else {
			return
		}
		
		lable.textColor = bagde.textColor
		lable.backgroundColor = bagde.backgroundColor
		lable.font = bagde.font
		
		if bagde.value == "" || (bagde.value == "0" && bagde.shouldHideAtZero) {
			lable.isHidden = true
		} else {
			lable.isHidden = false
			
			self.updateBadgeValue(bagde: bagde)
		}
	}
	
	func badgeExpectedSize(bagde: ALBarButtonItemBagde) -> CGSize {
		// When the value changes the badge could need to get bigger
		// Calculate expected size to fit new value
		// Use an intermediate label to get expected size thanks to sizeToFit
		// We don't call sizeToFit on the true label to avoid bad display
		guard let frameLabel = duplicate(bagde.label, bagde: bagde) else {
			return CGSize.zero
		}
	
		frameLabel.sizeToFit()	
			
		return frameLabel.frame.size
	}
	
	func updateBadgeFrame(bagde: ALBarButtonItemBagde) {
		guard let label = bagde.label else {
			return
		}
		
		let expectedLabelSize = self.badgeExpectedSize(bagde: bagde)
		
		let minHeight = expectedLabelSize.height < bagde.minSize ? bagde.minSize : expectedLabelSize.height
		
		let minWidth = expectedLabelSize.width < minHeight ? minHeight : expectedLabelSize.width
		
		label.layer.masksToBounds = true
		label.frame = CGRect(x: bagde.originX, y: bagde.originY, width: minWidth + bagde.paddingX, height: minHeight + bagde.paddingY)
		label.layer.cornerRadius = (minHeight + bagde.paddingY) / 2
	}
	
	func updateBadgeValue(bagde: ALBarButtonItemBagde) {
		guard let label = bagde.label else {
			return
		}
		
		if bagde.shouldAnimate && label.text != bagde.value {
			let animation = CABasicAnimation(keyPath: "transform.scale").apply {
				$0.fromValue = 1.5
				$0.toValue = 1
				$0.duration = 0.2
				$0.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1.0, 1.0)
			}
			
			label.layer.add(animation, forKey: "bounceAnimation")
		}
		
		label.text = bagde.value
		
		if bagde.shouldAnimate {
			UIView.animate(withDuration: 0.2, animations: {
				self.updateBadgeFrame(bagde: bagde)
			})
		} else {
			self.updateBadgeFrame(bagde: bagde)
		}
	}
	
	func duplicate(_ labelToCopy: UILabel?, bagde: ALBarButtonItemBagde) -> UILabel? {
		guard let label = labelToCopy else {
			return nil
		}
		
		return UILabel(frame: label.frame).apply {
			$0.text = label.text
			$0.font = label.font
		}
	}
	
	func removeBadge(bagde: ALBarButtonItemBagde) {
		UIView.animate(withDuration: 0.2, animations: {
			bagde.label?.transform = CGAffineTransform(scaleX: 0, y: 0)
		}, completion: { _ in
			bagde.label?.removeFromSuperview()
			
			bagde.label = nil
		})
	}
	
	func set(backgroundColor: UIColor, bagde: ALBarButtonItemBagde) {
		bagde.backgroundColor = backgroundColor
		
		self.refreshBadge(bagde: bagde)
	}
	
	func set(textColor: UIColor, bagde: ALBarButtonItemBagde) {
		bagde.textColor = textColor
		
		self.refreshBadge(bagde: bagde)
	}
	
	func set(font: UIFont, bagde: ALBarButtonItemBagde) {
		bagde.font = font
		
		self.refreshBadge(bagde: bagde)
	}
	
	func set(padding: CGFloat, bagde: ALBarButtonItemBagde) {
		bagde.padding = padding
		
		self.refreshBadge(bagde: bagde)
	}
	
	func set(minSize: CGFloat, bagde: ALBarButtonItemBagde) {
		bagde.minSize = minSize
		
		self.refreshBadge(bagde: bagde)
	}
	
	func set(originX: CGFloat, bagde: ALBarButtonItemBagde) {
		bagde.originX = originX
		
		self.refreshBadge(bagde: bagde)
	}
	
	func set(originY: CGFloat, bagde: ALBarButtonItemBagde) {
		bagde.originY = originY
		
		self.refreshBadge(bagde: bagde)
	}
	
	func set(shouldHideAtZero: Bool, bagde: ALBarButtonItemBagde) {
		bagde.shouldHideAtZero = shouldHideAtZero
		
		self.refreshBadge(bagde: bagde)
	}
	
	func set(shouldAnimate: Bool, bagde: ALBarButtonItemBagde) {
		bagde.shouldAnimate = shouldAnimate
		
		self.refreshBadge(bagde: bagde)
	}
}
