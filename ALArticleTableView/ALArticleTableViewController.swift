import UIKit
import SVGKit
import INSPullToRefresh

class ALArticleTableViewController: ALSwipeTabContentViewController {
	internal let tableView = UITableView()

    fileprivate let cellSetting = ALArticleTableViewCellSetting()
    
	internal var articles = [ALArticle]()
    internal var articlesAdd = [ALArticle]()
	
    override init(title: String, isSwipeTab: Bool, isSloppySwipe: Bool) {
		super.init(title: title, isSwipeTab: isSwipeTab, isSloppySwipe: isSloppySwipe)
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.cellLayoutMarginsFollowReadableWidth = false
		self.tableView.backgroundColor = .clear
        
        if let separatorInset = self.cellSetting.separatorInset {
            self.tableView.separatorInset = separatorInset
        }
		
		self.tableView.ins_addPullToRefresh(withHeight: 60.0, handler: {scrollView in
			self.pullToRefresh()
		})
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		if #available(iOS 11.0, *) {
			self.tableView.contentInsetAdjustmentBehavior = .never
		}
		
		super.viewDidLoad()
		
		self.tableView.frame = self.view.frame
        self.tableView.estimatedRowHeight = self.getCellHeight(width: self.tableView.frame.width)
		
		let heightStatusBar = UIApplication.shared.statusBarFrame.size.height
		let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 44
		
		self.tableView.contentInset.top = heightStatusBar + heightNavigationBar
		self.tableView.scrollIndicatorInsets.top = heightStatusBar + heightNavigationBar
		
        self.tableView.contentInset.top += self.contentInsetTop
        self.tableView.scrollIndicatorInsets.top += self.contentInsetTop
		
		let svgCircleWhite = SVGKImage(named: "Resource/Library/CircleWhite.svg")!
		svgCircleWhite.size = CGSize(width: 24, height: 24)
		let svgCircleLight = SVGKImage(named: "Resource/Library/CircleLight.svg")!
		svgCircleLight.size = CGSize(width: 24, height: 24)
		
		let defaultFrame = CGRect(x: 0, y: 0, width: 24, height: 24)
		let pullToRefresh = INSDefaultPullToRefresh(frame: defaultFrame, back: svgCircleLight.uiImage, frontImage: svgCircleWhite.uiImage.change(color: self.view.tintColor))!
		
		self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
		self.tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)
		
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
        
        self.tableView.contentInset.bottom = self.heightTabBar + self.contentInsetBottom
        self.tableView.scrollIndicatorInsets.bottom = self.heightTabBar + self.contentInsetBottom
    }
    
    func cell(alArticle: ALArticle) -> ALArticleTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ALArticle") as? ALArticleTableViewCell ?? ALArticleTableViewCell(setting: self.cellSetting)
        
        cell.alArticle = alArticle
        
        return cell
    }
    
    func getCellHeight(width: CGFloat) -> CGFloat {
        return 44.0
    }
    
	func didSelectRow(at indexPath: IndexPath) {
        self.open(alArticle: self.articles[indexPath.row])
	}
	
    func open(alArticle: ALArticle) {
    }
    
	func refresh(done: @escaping (UITableView) -> Void) {
		self.load(isRemove: true, done: {tableView in
			self.endPullToRefresh()
			
			done(self.tableView)
		})
	}
	
	func pullToRefresh() {
		self.load(isRemove: true, done: {tableView in
			self.endPullToRefresh()
		})
	}
	
	func endPullToRefresh() {
		self.tableView.ins_endPullToRefresh()
	}
	
	func beginPullToRefresh() {
		self.tableView.ins_beginPullToRefresh()
	}
}

extension ALArticleTableViewController {
	func load(isRemove: Bool, done: ((UITableView) -> Void)?) {
	}
}

extension ALArticleTableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.articles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cell(alArticle: self.articles[indexPath.row])
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
}
