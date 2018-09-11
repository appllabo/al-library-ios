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
	func badgeInit(barButtonItemBagde: ALBarButtonItemBagde) {
		guard let badge = barButtonItemBagde.label else {
			return
		}
		
		if let customView = self.customView {
			barButtonItemBagde.originX = customView.frame.size.width - badge.frame.size.width / 2
			
			customView.clipsToBounds = false
			
			customView.addSubview(badge)
		} else if let view = self.value(forKey: "view") as? UIView {
			barButtonItemBagde.originX = view.frame.size.width - badge.frame.size.width
			
			view.addSubview(badge)
		}
	}
	
	func refreshBadge(barButtonItemBagde: ALBarButtonItemBagde) {
		guard let badge = barButtonItemBagde.label else {
			return
		}
		
		badge.textColor = barButtonItemBagde.textColor
		badge.backgroundColor = barButtonItemBagde.backgroundColor
		badge.font = barButtonItemBagde.font
		
		if barButtonItemBagde.value == "" || (barButtonItemBagde.value == "0" && barButtonItemBagde.shouldHideAtZero) {
			badge.isHidden = true
		} else {
			badge.isHidden = false
			
			self.updateBadgeValue(barButtonItemBagde: barButtonItemBagde)
		}
	}
	
	func badgeExpectedSize(barButtonItemBagde: ALBarButtonItemBagde) -> CGSize {
		// When the value changes the badge could need to get bigger
		// Calculate expected size to fit new value
		// Use an intermediate label to get expected size thanks to sizeToFit
		// We don't call sizeToFit on the true label to avoid bad display
		let frameLabel = duplicate(barButtonItemBagde.label, barButtonItemBagde: barButtonItemBagde)?.apply {
			$0.sizeToFit()	
		}
		
		return frameLabel?.frame.size ?? CGSize.zero
	}
	
	func updateBadgeFrame(barButtonItemBagde: ALBarButtonItemBagde) {
		let expectedLabelSize = badgeExpectedSize(barButtonItemBagde: barButtonItemBagde)
		
		// Make sure that for small value, the badge will be big enough
		var minHeight = expectedLabelSize.height
		
		// Using a const we make sure the badge respect the minimum size
		minHeight = (minHeight < barButtonItemBagde.minSize) ? barButtonItemBagde.minSize : expectedLabelSize.height
		
		var minWidth = expectedLabelSize.width
		
		// Using const we make sure the badge doesn't get too smal
		minWidth = minWidth < minHeight ? minHeight : expectedLabelSize.width
		
		barButtonItemBagde.label?.run {
			$0.layer.masksToBounds = true
			$0.frame = CGRect(x: barButtonItemBagde.originX, y: barButtonItemBagde.originY, width: minWidth + barButtonItemBagde.paddingX, height: minHeight + barButtonItemBagde.paddingY)
			$0.layer.cornerRadius = (minHeight + barButtonItemBagde.paddingY) / 2
		}
	}
	
	func updateBadgeValue(barButtonItemBagde: ALBarButtonItemBagde) {
		if barButtonItemBagde.shouldAnimate && self.badge(barButtonItemBagde: barButtonItemBagde).text != barButtonItemBagde.value {
			let animation = CABasicAnimation(keyPath: "transform.scale").apply {
				$0.fromValue = 1.5
				$0.toValue = 1
				$0.duration = 0.2
				$0.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1.0, 1.0)
			}
			
			self.badge(barButtonItemBagde: barButtonItemBagde).layer.add(animation, forKey: "bounceAnimation")
		}
		
		self.badge(barButtonItemBagde: barButtonItemBagde).text = barButtonItemBagde.value
		
		if barButtonItemBagde.shouldAnimate {
			UIView.animate(withDuration: 0.2, animations: {
				self.updateBadgeFrame(barButtonItemBagde: barButtonItemBagde)
			})
		} else {
			self.updateBadgeFrame(barButtonItemBagde: barButtonItemBagde)
		}
	}
	
	func duplicate(_ labelToCopy: UILabel?, barButtonItemBagde: ALBarButtonItemBagde) -> UILabel? {
		guard let label = labelToCopy else {
			return nil
		}
		
		return UILabel(frame: label.frame).apply {
			$0.text = label.text
			$0.font = label.font
		}
	}
	
	func removeBadge(barButtonItemBagde: ALBarButtonItemBagde) {
		UIView.animate(withDuration: 0.2, animations: {
			self.badge(barButtonItemBagde: barButtonItemBagde).transform = CGAffineTransform(scaleX: 0, y: 0)
		}, completion: { _ in
			self.badge(barButtonItemBagde: barButtonItemBagde).removeFromSuperview()
			
			barButtonItemBagde.label = nil
		})
	}
	
	func badge(barButtonItemBagde: ALBarButtonItemBagde) -> UILabel {
		return barButtonItemBagde.label ?? UILabel(frame: CGRect(x: barButtonItemBagde.originX, y: barButtonItemBagde.originY, width: 20, height: 20)).apply {
			barButtonItemBagde.label = $0
			
			self.badgeInit(barButtonItemBagde: barButtonItemBagde)
			
			customView?.addSubview($0)
			
			$0.textAlignment = .center
		}
	}
	
	func set(value: String, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.value = value
		
		self.updateBadgeValue(barButtonItemBagde: barButtonItemBagde)
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
	
	func set(backgroundColor: UIColor, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.backgroundColor = backgroundColor
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
	
	func set(textColor: UIColor, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.textColor = textColor
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
	
	func set(font: UIFont, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.font = font
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
	
	func set(padding: CGFloat, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.padding = padding
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
	
	func set(minSize: CGFloat, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.minSize = minSize
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
	
	func set(originX: CGFloat, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.originX = originX
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
	
	func set(originY: CGFloat, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.originY = originY
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
	
	func set(shouldHideAtZero: Bool, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.shouldHideAtZero = shouldHideAtZero
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
	
	func set(shouldAnimate: Bool, barButtonItemBagde: ALBarButtonItemBagde) {
		barButtonItemBagde.shouldAnimate = shouldAnimate
		
		self.refreshBadge(barButtonItemBagde: barButtonItemBagde)
	}
}
