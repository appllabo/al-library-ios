import XLPagerTabStrip

class ALSwipeTabContentViewController : ALSloppySwipeViewController {
	override var contentInsetTop: CGFloat {
        if self.isSwipeTab == true {
            return 44.0 + super.contentInsetTop
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
		
		self.automaticallyAdjustsScrollViewInsets = false
		
		super.viewDidLoad()
	}
}

extension ALSwipeTabContentViewController : IndicatorInfoProvider {
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		return self.indicatorInfo
	}
}
