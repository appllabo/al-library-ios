import UIKit

class ALBarButtonItemBadge : NSObject {
	var label: UILabel?
	var value = ""
	var backgroundColor = UIColor.red
	var textColor = UIColor.white
	var font = UIFont.systemFont(ofSize: 11.0)
	var origin = CGPoint(x: 0.0, y: 0.0)
	var marginX = CGFloat(0.0)
	var marginY = CGFloat(2.0)
	var paddingX = CGFloat(8.0)
	var paddingY = CGFloat(2.0)
	var shouldHideAtZero = true
	var shouldAnimate = true
	var duration = 0.2
}

extension UIBarButtonItem {
	func reset(value: String, badge: ALBarButtonItemBadge) {
		badge.value = value
		
		badge.label?.removeFromSuperview()
		
		if let customView = self.customView {
			badge.origin = CGPoint(x: customView.frame.size.width, y: 0.0)
			
			let label = UILabel(frame: CGRect(x: badge.origin.x, y: badge.origin.y, width: 0.0, height: 0.0)).apply {
				$0.layer.masksToBounds = true
				$0.textAlignment = .center
			}
			
			badge.label = label
			
			customView.clipsToBounds = false
			
			customView.addSubview(label)
		} else if let view = self.value(forKey: "view") as? UIView {
			badge.origin = CGPoint(x: view.frame.size.width, y: 0.0)
			
			let label = UILabel(frame: CGRect(x: badge.origin.x, y: badge.origin.y, width: 0.0, height: 0.0)).apply {
				$0.layer.masksToBounds = true
				$0.textAlignment = .center
			}
			
			badge.label = label
			
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
	
	func updateBadgeFrame(label: UILabel, badge: ALBarButtonItemBadge) {
		let sizeContent = UILabel(frame: label.frame).apply {
			$0.text = label.text
			$0.font = label.font
			
			$0.sizeToFit()
		}.frame.size
		
		let height = sizeContent.height + badge.paddingY
		let width = sizeContent.width + badge.paddingX > height ? sizeContent.width + badge.paddingX : height
		
		let x = badge.origin.x + badge.marginX - width / 2.0
		let y = badge.origin.y + badge.marginY
		
		label.frame = CGRect(x: x, y: y, width: width, height: height)
		label.layer.cornerRadius = height / 2.0
	}
	
	func updateBadgeValue(badge: ALBarButtonItemBadge) {
		guard let label = badge.label else {
			return
		}
		
		if badge.shouldAnimate && label.text != badge.value {
			let animation = CABasicAnimation(keyPath: "transform.scale").apply {
				$0.fromValue = 1.5
				$0.toValue = 1
				$0.duration = badge.duration
				$0.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1.0, 1.0)
			}
			
			label.layer.add(animation, forKey: "bounceAnimation")
		}
		
		label.text = badge.value
		
		if badge.shouldAnimate {
			let sizeContent = UILabel(frame: label.frame).apply {
				$0.text = label.text
				$0.font = label.font
				
				$0.sizeToFit()
			}.frame.size
			
			let height = sizeContent.height + badge.paddingY
			
			let x = badge.origin.x + badge.marginX
			let y = badge.origin.y + badge.marginY + height / 2.0
			
			label.frame = CGRect(x: x, y: y, width: 0, height: 0)
			label.layer.cornerRadius = 0.0
			
			UIView.animate(withDuration: badge.duration, animations: {
				self.updateBadgeFrame(label: label, badge: badge)
			})
		} else {
			self.updateBadgeFrame(label: label, badge: badge)
		}
	}
	
	func removeBadge(badge: ALBarButtonItemBadge) {
		UIView.animate(withDuration: badge.duration, animations: {
			badge.label?.transform = CGAffineTransform(scaleX: 0, y: 0)
		}, completion: { _ in
			badge.label?.removeFromSuperview()
			
			badge.label = nil
		})
	}
}
