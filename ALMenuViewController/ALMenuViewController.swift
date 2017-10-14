import UIKit

class ALMenuViewController: ALSwipeTabContentViewController {
	internal let tableView = UITableView(frame: CGRect.zero, style: .grouped)
	
	internal enum SectionData {
		case String(String)
		case Array([SectionData])
		case Dictionary([String: SectionData])
		case Closure(() -> Void)
	}
	
	internal var sections: [[String: SectionData]] {
		return []
	}
	
	override init(title: String, isTabContent: Bool) {
		super.init(title: title, isTabContent: isTabContent)
		
		self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.backgroundColor = .clear
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		
		if self.isTabContent == true {
			self.tableView.contentInset.top = 64
			self.tableView.scrollIndicatorInsets.top = 64
			self.tableView.contentInset.bottom += 44
			self.tableView.scrollIndicatorInsets.bottom += 44
		}
		
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
					method()
				}
			}
		}
	}
}
