import UIKit
import SVGKit
import INSPullToRefresh

class ALArticleTableViewController : ALSwipeTabContentViewController {
	internal let tableView = UITableView()

    internal var separatorInset: UIEdgeInsets? {
        return nil
    }
    
	internal var articles = [ALArticle]()
    internal var articlesAdd = [ALArticle]()
	
    override init(title: String, isSloppySwipe: Bool, swipeTabViewController: ALSwipeTabViewController? = nil) {
		super.init(title: title, isSloppySwipe: isSloppySwipe, swipeTabViewController: swipeTabViewController)
		
        self.tableView.apply {
            $0.delegate = self
            $0.dataSource = self
            $0.cellLayoutMarginsFollowReadableWidth = false
        }.run {
            $0.ins_addPullToRefresh(withHeight: 60.0) { _ in
                self.pullToRefresh()
            }
        }
    }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		if #available(iOS 11.0, *) {
			self.tableView.contentInsetAdjustmentBehavior = .never
		}
		
		super.viewDidLoad()
		
        self.tableView.run {
            $0.frame = self.view.bounds
            $0.estimatedRowHeight = self.getCellHeight(width: self.tableView.frame.width)
            $0.backgroundColor = .clear
            
			$0.contentInset.top = self.contentInsetTop
			$0.scrollIndicatorInsets.top = self.contentInsetTop
			
            if let separatorInset = self.separatorInset {
                $0.separatorInset = separatorInset
            }
            
            let svgCircleWhite = SVGKImage(named: "Resource/Library/CircleWhite.svg")?.apply {
                $0.size = CGSize(width: 24, height: 24)
            }
            let svgCircleLight = SVGKImage(named: "Resource/Library/CircleLight.svg")?.apply {
                $0.size = CGSize(width: 24, height: 24)
            }
        	
            let defaultFrame = CGRect(x: 0, y: 0, width: 24, height: 24)
        	
            if let pullToRefresh = INSDefaultPullToRefresh(frame: defaultFrame, back: svgCircleLight?.uiImage, frontImage: svgCircleWhite?.uiImage.change(color: self.view.tintColor)) {
                $0.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
                $0.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)
            }
        }
		
		self.view.addSubview(self.tableView)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let indexPath = self.tableView.indexPathForSelectedRow {
			self.tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.run {
            $0.contentInset.bottom = self.heightTabBar + self.contentInsetBottom
            $0.scrollIndicatorInsets.bottom = self.heightTabBar + self.contentInsetBottom
        }
    }
    
    func cell(alArticle: ALArticle) -> ALArticleTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ALArticle") as? ALArticleTableViewCell ?? ALArticleTableViewCell(setting: ALArticleTableViewCellSetting())
    }
    
	func didSelectRow(at indexPath: IndexPath) {
        self.open(alArticle: self.articles[indexPath.row])
	}
	
	func pullToRefresh() {
		self.refreshTable { tableView in
			self.endPullToRefresh()
		}
	}
	
	func endPullToRefresh() {
		self.tableView.ins_endPullToRefresh()
	}
	
	func beginPullToRefresh() {
		self.tableView.ins_beginPullToRefresh()
	}
}

extension ALArticleTableViewController {
	@objc func getCellHeight(width: CGFloat) -> CGFloat {
		return 44.0
	}
	
	@objc func open(alArticle: ALArticle) {
	}
	
	@objc func refresh(done: ((UITableView) -> Void)? = nil) {
		self.refreshTable { tableView in
			self.endPullToRefresh()
			
			done?(self.tableView)
		}
	}
	
	@objc func refreshTable(done: ((UITableView) -> Void)? = nil) {
	}
	
	@objc func onReachMaxNum() {
	}
	
	@objc func loadNext() {
	}
}

extension ALArticleTableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.articles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = self.articles[indexPath.row]
        
        return self.cell(alArticle: article).apply {
            $0.alArticle = article
        }
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getCellHeight(width: tableView.frame.width)
	}
}

extension ALArticleTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.didSelectRow(at: indexPath)
        
        if let cell = tableView.cellForRow(at: indexPath) as? ALArticleTableViewCell {
            cell.read()
        }
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if self.articles.count >= 300 {
			return
		}
		
		// TODO:inset等を考慮して要修正.
		if scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y + scrollView.frame.height * 2 >= scrollView.contentSize.height {
			print("ALArticleTableViewController:scrollViewDidScroll:start")
			
			self.loadNext()
		}
	}
}
