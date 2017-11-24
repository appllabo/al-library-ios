import UIKit
import SVGKit
import INSPullToRefresh

class ALTagTableViewController: ALSwipeTabContentViewController {
	internal let tableView = UITableView()
	
	internal let cellSetting: ALTagTableViewCellSetting
	
	internal var tags = [ALTag]()
	internal var cells = [ALTagTableViewCell]()
	
	init(title: String, isTabContent: Bool, cellSetting: ALTagTableViewCellSetting, isSloppySwipe: Bool) {
		self.cellSetting = cellSetting
		
		super.init(title: title, isTabContent: isTabContent, isSloppySwipe: isSloppySwipe)
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.cellLayoutMarginsFollowReadableWidth = false
		self.tableView.backgroundColor = .clear
		
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
		
		let heightStatusBar = UIApplication.shared.statusBarFrame.size.height
		let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 44
		
		self.tableView.contentInset.top = heightStatusBar + heightNavigationBar
		self.tableView.scrollIndicatorInsets.top = heightStatusBar + heightNavigationBar
		
		if self.isTabContent == true {
			self.tableView.contentInset.top += 44.0
			self.tableView.scrollIndicatorInsets.top += 44.0
		}
		
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
	
	func open(tag: ALTag) {
	}
	
	func refresh() {
		self.load(done: {})
	}
	
	func pullToRefresh() {
		self.load(done: {
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

extension ALTagTableViewController {
	func load(done: @escaping () -> Void) {
	}
}

extension ALTagTableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.cells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.cells[indexPath.row]
	}
}

extension ALTagTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.open(tag: self.tags[indexPath.row])
	}
}

