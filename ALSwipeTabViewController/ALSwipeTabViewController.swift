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
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.changeCurrentIndexProgressive = { oldCell, newCell, progressPercentage, changeCurrentIndex, animated in
			guard changeCurrentIndex == true else { return }
			
			oldCell?.label.textColor = self.settings.style.buttonBarItemTitleColor
			newCell?.label.textColor = self.settings.style.selectedBarBackgroundColor
			
            // TODO
			oldCell?.label.font = self.settings.style.buttonBarItemFont
			newCell?.label.font = .boldSystemFont(ofSize: 14)
		}
        
		super.viewDidLoad()
		
		self.containerView.frame = self.view.bounds
		self.buttonBarView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height + self.heightNavigationBar, width: self.buttonBarView.frame.width, height: self.buttonBarView.frame.height)
		
		let viewUnderBar = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height + self.heightNavigationBar + self.buttonBarView.frame.height, width: self.view.frame.width, height: 1.0 / UIScreen.main.scale)).apply {
			$0.backgroundColor = UIColor(hex: 0x000000, alpha: 0.3)
		}
		
		self.view.addSubview(viewUnderBar)
	}
	
	override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
		return self.swipeTabContentViewControllers
	}
}
