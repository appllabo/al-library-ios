import XLPagerTabStrip

class ALSwipeTabContentViewController: ALSloppySwipeViewController {
	internal let indicatorInfo: IndicatorInfo
	internal let isTabContent: Bool
	
	init(title: String, isTabContent: Bool) {
		self.indicatorInfo = IndicatorInfo(title: title)
		self.isTabContent = isTabContent
		
		super.init(isSloppySwipe: !self.isTabContent)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		self.automaticallyAdjustsScrollViewInsets = false
		
		super.viewDidLoad()
		
		self.title = self.indicatorInfo.title
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
