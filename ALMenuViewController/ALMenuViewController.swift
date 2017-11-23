import UIKit

class ALMenuViewController: ALSwipeTabContentViewController {
	internal let tableView = UITableView(frame: CGRect.zero, style: .grouped)
	
	internal enum SectionData {
		case String(String)
		case Array([SectionData])
		case Dictionary([String: SectionData])
		case Closure((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)
	}
	
	internal var sections: [[String: SectionData]] {
		return []
	}
	
	override init(title: String, isTabContent: Bool, isSloppySwipe: Bool) {
		super.init(title: title, isTabContent: isTabContent, isSloppySwipe: isSloppySwipe)
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.backgroundColor = .clear
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
}

extension ALMenuViewController {	
	internal func deselectRow() {
		if let indexPath = self.tableView.indexPathForSelectedRow {
			self.tableView.deselectRow(at: indexPath, animated: true)
		}
	}
}

extension ALMenuViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.sections.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if case let .String(header) = self.sections[section]["header"]! {
			return header
		}
		
		return ""
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if case let .Array(contents) = self.sections[section]["contents"]! {
			return contents.count
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
		
		if case let .Array(contents) = self.sections[indexPath.section]["contents"]! {
			if case let .Dictionary(content) = contents[indexPath.row] {
				if case let .String(label) = content["label"]! {
					cell.textLabel?.text = label
				}
				
				if let detail = content["detail"] {
					if case let .String(text) = detail {
						cell.detailTextLabel?.text = text
						cell.detailTextLabel?.textAlignment = .right
					}
				}
			}
		}
		
		cell.accessoryType = .disclosureIndicator
		
		return cell
	}
}

extension ALMenuViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if case let .Array(contents) = self.sections[indexPath.section]["contents"]! {
			if case let .Dictionary(content) = contents[indexPath.row] {
				if case let .Closure(method) = content["method"]! {
					method(tableView, indexPath)
				}
			}
		}
	}
}
