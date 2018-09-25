import XLPagerTabStrip

class ALSwipeTabContentViewController : ALSloppySwipeViewController {
	override var contentInsetTop: CGFloat {
        let heightStatusBar = UIApplication.shared.statusBarFrame.size.height
        
        if let swipeTabViewController = self.swipeTabViewController {
            let heightNavigationBar = swipeTabViewController.navigationController?.navigationBar.frame.size.height ?? 0
			let buttonBarHeight = swipeTabViewController.settings.style.buttonBarHeight ?? 0
			
			return heightStatusBar + heightNavigationBar + buttonBarHeight
        } else {
            let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 0
            
            return heightStatusBar + heightNavigationBar
        }
    }
    
	internal let indicatorInfo: IndicatorInfo
	internal var swipeTabViewController: ALSwipeTabViewController?
	
	init(title: String, isSloppySwipe: Bool, swipeTabViewController: ALSwipeTabViewController? = nil) {
		self.indicatorInfo = IndicatorInfo(title: title)
		self.swipeTabViewController = swipeTabViewController
		
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
