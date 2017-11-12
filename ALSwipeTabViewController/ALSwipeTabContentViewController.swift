import XLPagerTabStrip

class ALSwipeTabContentViewController: ALSloppySwipeViewController {
	internal let indicatorInfo: IndicatorInfo
	internal let isTabContent: Bool
	
	init(title: String, isTabContent: Bool, isSloppySwipe: Bool) {
		self.indicatorInfo = IndicatorInfo(title: title)
		self.isTabContent = isTabContent
		
		super.init(isSloppySwipe: isSloppySwipe)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		self.automaticallyAdjustsScrollViewInsets = false
		
		super.viewDidLoad()
		
		self.title = self.indicatorInfo.title
		
		if (self.isTabContent == true) {
			self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 44.0, width: self.view.frame.width, height: self.view.frame.height)
		}
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
