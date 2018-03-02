import UIKit

class ALStackPageViewController: ALSloppySwipePageViewController {
	private let titleView = UIView()
	
	internal let labelTitle = UILabel()
	
    private let stackViewTitlePage = UIStackView()
    internal let labelTitleTop = UILabel()
    internal let pageControl = UIPageControl()
    
	private let stackViewWebsiteTitle = UIStackView()
	internal let labelWebsiteTop = UILabel()
	internal let labelTitleBottom = UILabel()
	
	internal var isEnableForward: Bool = false
    
	internal var colorLabelTitleTop: UIColor {
		return .init(hex: 0x000000, alpha: 1.0)
	}
	
	internal var colorLabelWebsiteTop: UIColor {
		return .init(hex: 0x808080, alpha: 1.0)
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
		self.labelTitle.font = .boldSystemFont(ofSize: 16)
		self.labelTitle.textColor = self.colorLabelTitleTop
		self.labelTitle.textAlignment = .center
		
		self.stackViewTitlePage.axis = .vertical
		self.stackViewTitlePage.alignment = .center
		self.stackViewTitlePage.distribution = .fill
		self.stackViewTitlePage.frame = CGRect(x: 0, y: 4, width: self.titleView.frame.width, height: 36)
		self.stackViewTitlePage.alpha = 0.0
		
		self.labelTitleTop.font = .boldSystemFont(ofSize: 16)
		self.labelTitleTop.textColor = self.colorLabelTitleTop
		self.labelTitleTop.numberOfLines = 1
		
		self.pageControl.pageIndicatorTintColor = self.colorLabelWebsiteTop
		self.pageControl.currentPageIndicatorTintColor = self.view.tintColor
		self.pageControl.backgroundColor = .clear
		self.pageControl.numberOfPages = 1
		self.pageControl.currentPage = self.index
		self.pageControl.isUserInteractionEnabled = false
		self.pageControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
		
		self.stackViewTitlePage.addArrangedSubview(self.labelTitleTop)
		self.stackViewTitlePage.addArrangedSubview(self.pageControl)
		
		self.stackViewWebsiteTitle.axis = .vertical
		self.stackViewWebsiteTitle.alignment = .center
		self.stackViewWebsiteTitle.distribution = .fillEqually
		self.stackViewWebsiteTitle.frame = CGRect(x: 0, y: 0, width: self.titleView.frame.width, height: 40)
		self.stackViewWebsiteTitle.alpha = 0.0
		
		self.labelWebsiteTop.font = .systemFont(ofSize: 11)
		self.labelWebsiteTop.textColor = self.colorLabelWebsiteTop
		self.labelWebsiteTop.attributedText = (self.contentViewControllers[self.index] as! ALStackPageContentViewController).attributedTitleSub
		
		self.labelTitleBottom.font = .boldSystemFont(ofSize: 16)
		self.labelTitleBottom.textColor = self.colorLabelTitleTop
		self.labelTitleBottom.attributedText = (self.contentViewControllers[self.index] as! ALStackPageContentViewController).attributedTitleMain
		
		self.stackViewWebsiteTitle.addArrangedSubview(self.labelWebsiteTop)
		self.stackViewWebsiteTitle.addArrangedSubview(self.labelTitleBottom)
		
		self.titleView.addSubview(self.labelTitle)
		self.titleView.addSubview(self.stackViewWebsiteTitle)
		self.titleView.addSubview(self.stackViewTitlePage)
		
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
				self.stackViewWebsiteTitle.alpha = 0.0
			} else if scrollView.contentOffset.y <= -scrollView.contentInset.top + 128 {
				let alpha = (-scrollView.contentInset.top + 128 - scrollView.contentOffset.y) / 128.0
				self.labelTitle.alpha = easeInCirc(position: alpha)
				self.stackViewWebsiteTitle.alpha = easeInCirc(position: 1.0 - alpha)
			} else {
				self.labelTitle.alpha = 0.0
				self.stackViewWebsiteTitle.alpha = 1.0
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
				self.stackViewWebsiteTitle.alpha = 0.0
				self.labelTitle.alpha = 0.0
				self.stackViewTitlePage.alpha = 1.0
			//}
		}
	}
	
	func easeInCirc(position: CGFloat) -> CGFloat {
		return -(CGFloat(sqrt(1.0 - position * position)) - 1.0)
	}
	
	func updateTitle(viewController: ArticleViewController) {
		self.labelTitle.text = viewController.title
		self.labelTitleTop.attributedText = viewController.attributedTitleMain
		self.labelWebsiteTop.attributedText = viewController.attributedTitleSub
		self.labelTitleBottom.attributedText = viewController.attributedTitleMain
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
        
        let indexNext = self.index + 1
        
        if self.index < self.contentViewControllers.count - 1 {
            self.contentViewControllers[indexNext...self.contentViewControllers.count - 1] = []
        }
        
        self.contentViewControllers.append(viewController)
		
		self.labelTitle.text = viewController.title
		self.labelTitleTop.attributedText = viewController.attributedTitleMain
		self.labelTitleBottom.attributedText = viewController.attributedTitleMain
		self.labelWebsiteTop.attributedText = viewController.attributedTitleSub
		
		self.labelTitle.alpha = 0.0
		self.stackViewWebsiteTitle.alpha = 0.0
		self.stackViewTitlePage.alpha = 1.0
		
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
			self.labelTitleTop.attributedText = contentViewController.attributedTitleMain
			self.labelTitleBottom.attributedText = contentViewController.attributedTitleMain
			self.labelWebsiteTop.attributedText = contentViewController.attributedTitleSub
		}
		
		if self.index == self.contentViewControllers.count - 1 {
			self.isEnableForward = false
		} else {
			self.isEnableForward = true
		}
	}
}
