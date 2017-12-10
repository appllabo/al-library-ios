import XLPagerTabStrip

class ALSwipeTabContentViewController: ALSloppySwipeViewController {
	internal let indicatorInfo: IndicatorInfo
	internal let isSwipeTab: Bool
	
    internal var contentInsetTop: CGFloat {
        if self.isSwipeTab == true {
            return 44.0
        } else {
            return 0.0
        }
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
    
	init(title: String, isSwipeTab: Bool, isSloppySwipe: Bool) {
		self.indicatorInfo = IndicatorInfo(title: title)
		self.isSwipeTab = isSwipeTab
		
		super.init(isSloppySwipe: isSloppySwipe)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		self.automaticallyAdjustsScrollViewInsets = false
		
		super.viewDidLoad()
		
		self.title = self.indicatorInfo.title
		
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - self.contentInsetTop, width: self.view.frame.width, height: self.view.frame.height)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
}

extension ALSwipeTabContentViewController: IndicatorInfoProvider {
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return self.indicatorInfo
	}
}
