import UIKit
import SVGKit
import INSPullToRefresh

class ALImageArticleTableViewController: ALSwipeTabContentViewController {
	internal let tableView = UITableView()
	
	internal let cellSetting: ALImageArticleTableViewCellSetting
	internal var articles = [ALArticle]()
	internal var cells = [ALImageArticleTableViewCell]()
	
	init(title: String, isTabContent: Bool, cellSetting: ALImageArticleTableViewCellSetting, isSloppySwipe: Bool) {
		self.cellSetting = cellSetting
		
		super.init(title: title, isTabContent: isTabContent, isSloppySwipe: isSloppySwipe)
		
		self.tableView.frame = self.view.frame
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.separatorInset = UIEdgeInsetsMake(0, self.cellSetting.paddingImage.left, 0, 0)
		self.tableView.cellLayoutMarginsFollowReadableWidth = false
		self.tableView.backgroundColor = .clear
		
		if self.isTabContent == true {
			self.tableView.contentInset.top = 64
			self.tableView.scrollIndicatorInsets.top = 64
			self.tableView.contentInset.bottom += 44
			self.tableView.scrollIndicatorInsets.bottom += 44
		}
		
		let svgCircleWhite = SVGKImage(named: "Resource/Library/CircleWhite.svg")!
		svgCircleWhite.size = CGSize(width: 24, height: 24)
		let svgCircleLight = SVGKImage(named: "Resource/Library/CircleLight.svg")!
		svgCircleLight.size = CGSize(width: 24, height: 24)
		
		let defaultFrame = CGRect(x: 0, y: 0, width: 24, height: 24)
		let pullToRefresh = INSDefaultPullToRefresh(frame: defaultFrame, back: svgCircleLight.uiImage, frontImage: svgCircleWhite.uiImage.change(color: self.view.tintColor))!
		
		self.tableView.ins_addPullToRefresh(withHeight: 60.0, handler: {scrollView in
			self.pullToRefresh()
		})
		
		self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
		self.tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)
		
		self.view.addSubview(self.tableView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		if #available(iOS 11.0, *) {
			self.tableView.contentInsetAdjustmentBehavior = .never
		}
		
		super.viewDidLoad()
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
	
	func open(article: ALArticle) {
	}
	
	func pullToRefresh() {
		self.load(isRemove: true, done: {
			self.tableView.ins_endPullToRefresh()
		})
	}
	
	func refresh() {
		self.tableView.ins_beginPullToRefresh()
		
		self.load(isRemove: true, done: {
			self.tableView.ins_endPullToRefresh()
		})
	}
}

extension ALImageArticleTableViewController {
	func load(isRemove: Bool, done: @escaping () -> Void) {
	}}

extension ALImageArticleTableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.cells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.cells[indexPath.row]
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 54 + tableView.frame.width / 16 * 9 + 64
	}
}

extension ALImageArticleTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.articles[indexPath.row].isRead = true
		self.cells[indexPath.row].read()
		
		self.open(article: self.articles[indexPath.row])
	}
}
