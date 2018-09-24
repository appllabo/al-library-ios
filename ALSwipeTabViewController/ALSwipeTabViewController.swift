import XLPagerTabStrip

class ALSwipeTabViewController : ButtonBarPagerTabStripViewController {
	internal var swipeTabContentViewControllers = [ALSwipeTabContentViewController]()
	
	init() {
		print("ALSwipeTabViewController:init")
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
//		self.automaticallyAdjustsScrollViewInsets = false
		
		super.viewDidLoad()
	}
	
	override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
		return self.swipeTabContentViewControllers
	}
}
