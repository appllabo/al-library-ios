import UIKit

protocol ALApply { }

extension ALApply {
	func apply(closure: (Self) -> Void) -> Self {
		closure(self)
		
		return self
	}
}

extension NSObject: ALApply { }

extension UIColor {
	convenience init(hex: Int, alpha: CGFloat) {
		let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
		let b = CGFloat(hex & 0x0000FF) / 255.0
		
		self.init(red: r, green: g, blue: b, alpha: alpha)
	}
	
	convenience init(hex1: Int, hex2: Int, blend: CGFloat, alpha: CGFloat) {
		let r1 = CGFloat((hex1 & 0xFF0000) >> 16) / 255.0
		let g1 = CGFloat((hex1 & 0x00FF00) >> 8) / 255.0
		let b1 = CGFloat(hex1 & 0x0000FF) / 255.0
		
		let r2 = CGFloat((hex2 & 0xFF0000) >> 16) / 255.0
		let g2 = CGFloat((hex2 & 0x00FF00) >> 8) / 255.0
		let b2 = CGFloat(hex2 & 0x0000FF) / 255.0
		
		let r = r1 * (1.0 - blend) + r2 * blend
		let g = g1 * (1.0 - blend) + g2 * blend 
		let b = b1 * (1.0 - blend) + b2 * blend
		
		self.init(red: r, green: g, blue: b, alpha: alpha)
	}
}

extension UIImage {
	func resize(size: CGSize) -> UIImage? {
		let widthRatio = size.width / self.size.width
		let heightRatio = size.height / self.size.height
		let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
		
		let resizedSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
		
		UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
		
		draw(in: CGRect(origin: .zero, size: resizedSize))
		
		let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		return resizedImage
	}
	
	func change(color: UIColor) -> UIImage {
		var image = withRenderingMode(.alwaysTemplate)
		
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		
		color.set()
		
		image.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
		
		if let currentImageContext = UIGraphicsGetImageFromCurrentImageContext() {
			image = currentImageContext
		}
		
		UIGraphicsEndImageContext()
		
		return image
	}
}
