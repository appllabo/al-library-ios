import UIKit
import SVGKit
import INSPullToRefresh

class ALWebsiteTableViewController: ALSwipeTabContentViewController {
	internal let tableView = UITableView()
	
	internal var websites: [ALWebsite]
	internal var cells = [ALWebsiteTableViewCell]()
	
	init(title: String, websites: [ALWebsite], isSwipeTab: Bool, isSloppySwipe: Bool, cellSetting: ALWebsiteTableViewCellSetting) {
		self.websites = websites
		
		super.init(title: title, isSwipeTab: isSwipeTab, isSloppySwipe: isSloppySwipe)
		
        self.tableView.apply {
            $0.delegate = self
            $0.dataSource = self
            $0.cellLayoutMarginsFollowReadableWidth = false
            $0.backgroundColor = .clear
        }.run {
            $0.ins_addPullToRefresh(withHeight: 60.0, handler: { _ in
                self.pullToRefresh()
            })
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
            $0.frame = self.view.frame
            
            let heightStatusBar = UIApplication.shared.statusBarFrame.size.height
            let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 44
            
            $0.contentInset.top = heightStatusBar + heightNavigationBar
            $0.scrollIndicatorInsets.top = heightStatusBar + heightNavigationBar
            
            $0.contentInset.top += self.contentInsetTop
            $0.scrollIndicatorInsets.top += self.contentInsetTop
            
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
	
	func open(alWebsite: ALWebsite) {
	}
	
	func refresh() {
		self.load()
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

extension ALWebsiteTableViewController {
	func load(done: (() -> Void)? = nil) {
	}
}

extension ALWebsiteTableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.cells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.cells[indexPath.row]
	}
}

extension ALWebsiteTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.open(alWebsite: self.websites[indexPath.row])
	}
}
