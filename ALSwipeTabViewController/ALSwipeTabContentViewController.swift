import XLPagerTabStrip

class ALSwipeTabContentViewController : ALSloppySwipeViewController {
	override var contentInsetTop: CGFloat {
        if self.isSwipeTab == true {
			if #available(iOS 11.0, *) {
				return 44
			} else {
				let heightStatusBar = UIApplication.shared.statusBarFrame.size.height
				let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 44
				
				return super.contentInsetTop + heightStatusBar + heightNavigationBar + 44
			}
        } else {
            return super.contentInsetTop
        }
    }
    
	internal let indicatorInfo: IndicatorInfo
	internal let isSwipeTab: Bool
	
	init(title: String, isSwipeTab: Bool, isSloppySwipe: Bool) {
		self.indicatorInfo = IndicatorInfo(title: title)
		self.isSwipeTab = isSwipeTab
		
		super.init(isSloppySwipe: isSloppySwipe)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		self.title = self.indicatorInfo.title
		
		super.viewDidLoad()
	}
}

extension ALSwipeTabContentViewController : IndicatorInfoProvider {
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return self.indicatorInfo
	}
}
