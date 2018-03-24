import UIKit

class ALStackPageViewController: ALSloppySwipePageViewController {
	private let titleView = UIView()
	
	private let stackViewTitle = UIStackView()
    
    internal let labelTitle = UILabel()
	internal let labelTitleMain = UILabel()
    internal let labelTitleSub = UILabel()
    
    internal let pageControl = UIPageControl()
    
	internal var isEnableForward: Bool = false
    
	internal var colorTitleMain: UIColor {
		return .init(hex: 0x000000, alpha: 1.0)
	}
	
	internal var colorTitleSub: UIColor {
		return .init(hex: 0x808080, alpha: 1.0)
	}
	
    internal var colorTitlePage: UIColor {
        return .init(hex: 0xa0a0a0, alpha: 1.0)
    }
    
    internal var fontTitleMain: UIFont {
        return .boldSystemFont(ofSize: 16)
    }
    
    internal var fontTitleSub: UIFont {
        return .systemFont(ofSize: 11)
    }
    
	internal var titleViewFrame: CGRect {
		return .init(x: 0, y: 0, width: self.view.frame.width - 96, height: 44)
	}
	
    init(contentViewController: ALStackPageContentViewController, isSloppySwipe: Bool) {
		super.init(contentViewController: contentViewController, transitionStyle: .scroll, navigationOrientation: .horizontal, isSloppySwipe: isSloppySwipe, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.setViewControllers(self.contentViewControllers, direction: .forward, animated: true, completion: nil)
		
		self.titleView.frame = titleViewFrame
		
		self.labelTitle.text = self.contentViewControllers[0].title
		self.labelTitle.frame = self.titleView.frame
		self.labelTitle.numberOfLines = 2
		self.labelTitle.font = self.fontTitleMain
		self.labelTitle.textColor = self.colorTitleMain
		self.labelTitle.textAlignment = .center
		
        self.stackViewTitle.axis = .vertical
        self.stackViewTitle.alignment = .center
        self.stackViewTitle.distribution = .fillEqually
        self.stackViewTitle.frame = CGRect(x: 0, y: 0, width: self.titleView.frame.width, height: 40)
        self.stackViewTitle.alpha = 0.0
        
        self.labelTitleSub.font = self.fontTitleSub
        self.labelTitleSub.textColor = self.colorTitleSub
        self.labelTitleSub.attributedText = (self.contentViewControllers[self.index] as! ALStackPageContentViewController).attributedTitleSub
        
        self.labelTitleMain.font = self.fontTitleMain
        self.labelTitleMain.textColor = self.colorTitleMain
        self.labelTitleMain.attributedText = (self.contentViewControllers[self.index] as! ALStackPageContentViewController).attributedTitleMain
        
        self.pageControl.pageIndicatorTintColor = self.colorTitlePage
        self.pageControl.currentPageIndicatorTintColor = self.view.tintColor
        self.pageControl.backgroundColor = .clear
        self.pageControl.numberOfPages = 1
        self.pageControl.currentPage = self.index
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        self.stackViewTitle.addArrangedSubview(self.labelTitleSub)
        self.stackViewTitle.addArrangedSubview(self.labelTitleMain)
        
		self.titleView.addSubview(self.labelTitle)
		self.titleView.addSubview(self.stackViewTitle)
//        self.titleView.addSubview(self.stackViewNext)
		
		self.navigationItem.titleView = self.titleView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
	
	func scrollContentView(_ scrollView: UIScrollView) {
		if self.contentViewControllers.count == 1 {
			if scrollView.contentOffset.y <= -scrollView.contentInset.top {
				self.labelTitle.alpha = 1.0
				self.stackViewTitle.alpha = 0.0
			} else if scrollView.contentOffset.y <= -scrollView.contentInset.top + 128 {
				let alpha = (-scrollView.contentInset.top + 128 - scrollView.contentOffset.y) / 128.0
				self.labelTitle.alpha = easeInCirc(position: alpha)
				self.stackViewTitle.alpha = easeInCirc(position: 1.0 - alpha)
			} else {
				self.labelTitle.alpha = 0.0
				self.stackViewTitle.alpha = 1.0
			}
		} else {
			/*if scrollView.contentOffset.y <= -scrollView.contentInset.top {
				self.labelTitle.alpha = 1.0
				self.stackViewTitlePage.alpha = 0.0
			} else if scrollView.contentOffset.y <= -scrollView.contentInset.top + 128 {
				let alpha = (-scrollView.contentInset.top + 128 - scrollView.contentOffset.y) / 128.0
				self.labelTitle.alpha = easeInCirc(position: alpha)
				self.stackViewTitlePage.alpha = easeInCirc(position: 1.0 - alpha)
			} else {*/
				self.stackViewTitle.alpha = 1.0
				self.labelTitle.alpha = 0.0
//                self.stackViewNext.alpha = 1.0
			//}
		}
	}
	
	func easeInCirc(position: CGFloat) -> CGFloat {
		return -(CGFloat(sqrt(1.0 - position * position)) - 1.0)
	}
	
	func updateTitle(viewController: ArticleViewController) {
		self.labelTitle.text = viewController.title
        self.labelTitleMain.attributedText = viewController.attributedTitleMain
		self.labelTitleSub.attributedText = viewController.attributedTitleSub
	}
	
    func goBack(_ sender: UIButton) {
        if self.index > 0 {
            let indexNext = self.index - 1
            
            self.setViewControllers([self.contentViewControllers[indexNext]], direction: .reverse, animated: true) {bool -> Void in
                self.isEnableForward = true
                self.index = indexNext
                self.pageControl.currentPage = self.index
                
				if self.index > 0 {
					self.disableGesture = true
				} else {
					self.disableGesture = false
				}
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func goForward(_ sender: UIButton) {
        if self.index < self.contentViewControllers.count - 1 {
            let indexNext = self.index + 1
            
            self.setViewControllers([self.contentViewControllers[indexNext]], direction: .forward, animated: true) {bool -> Void in
                self.index = indexNext
                self.pageControl.currentPage = self.index
                
                if indexNext == self.contentViewControllers.count - 1 {
                    self.isEnableForward = false
                } else {
                    self.isEnableForward = true
                }
                
				if self.index > 0 {
					self.disableGesture = true
				} else {
					self.disableGesture = false
				}
            }
        }
    }
	
	func backHome(sender: UIButton) {
		self.navigationController?.popToRootViewController(animated: true)
	}
	
	func backPrev(sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func push(viewController: ALStackPageContentViewController) {
        if self.isScrolling == true || self.isMoving == true {
            return
        }
        
		self.isMoving = true
		self.isEnableForward = false
        self.scrollView?.isScrollEnabled = false
        
        if self.index == 0 {
            self.stackViewTitle.axis = .vertical
            self.stackViewTitle.alignment = .center
            self.stackViewTitle.distribution = .fill
            self.stackViewTitle.frame = CGRect(x: 0, y: 4, width: self.titleView.frame.width, height: 36)
            self.stackViewTitle.alpha = 0.0
            
            self.labelTitleSub.removeFromSuperview()
            self.stackViewTitle.addArrangedSubview(self.labelTitleMain)
            self.stackViewTitle.addArrangedSubview(self.pageControl)
        }
        
        let indexNext = self.index + 1
        
        if self.index < self.contentViewControllers.count - 1 {
            self.contentViewControllers[indexNext...self.contentViewControllers.count - 1] = []
        }
        
        self.contentViewControllers.append(viewController)
		
		self.labelTitle.text = viewController.title
		self.labelTitleMain.attributedText = viewController.attributedTitleMain
		self.labelTitleSub.attributedText = viewController.attributedTitleSub
		
		self.labelTitle.alpha = 0.0
//        self.stackViewTitle.alpha = 0.0
//        self.stackViewNext.alpha = 1.0

		self.setViewControllers([viewController], direction: .forward, animated: true) {bool -> Void in
			self.index = indexNext
            self.isMoving = false
            self.scrollView?.isScrollEnabled = true
            self.pageControl.numberOfPages = self.contentViewControllers.count
			self.pageControl.currentPage = self.index
			
			if self.index > 0 {
				self.disableGesture = true
			} else {
				self.disableGesture = false
			}
        }
    }
}

extension ALStackPageViewController {	
	override func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		super.pageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
		
		self.pageControl.currentPage = self.index
		
		if let contentViewController = self.contentViewControllers[self.index] as? ALStackPageContentViewController {
			self.labelTitleMain.attributedText = contentViewController.attributedTitleMain
			self.labelTitleSub.attributedText = contentViewController.attributedTitleSub
		}
		
		if self.index == self.contentViewControllers.count - 1 {
			self.isEnableForward = false
		} else {
			self.isEnableForward = true
		}
	}
}
