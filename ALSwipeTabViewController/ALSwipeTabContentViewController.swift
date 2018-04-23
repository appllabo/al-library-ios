import XLPagerTabStrip

class ALSwipeTabContentViewController: ALSloppySwipeViewController {
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
		
		self.title = self.indicatorInfo.title
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		self.automaticallyAdjustsScrollViewInsets = false
		
		super.viewDidLoad()
		
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
