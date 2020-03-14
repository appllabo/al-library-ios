import UIKit

public class ALMenuTableViewCellSetting : NSObject {
    public var font = UIFont.systemFont(ofSize: 17)
    public var color = UIColor.black
}

class ALMenuViewController : ALSwipeTabContentViewController {
    internal enum SectionData {
        case String(String)
        case Array([SectionData])
        case Dictionary([String: SectionData])
        case Closure((UITableView, IndexPath) -> Void)
    }
    
	internal let tableView = UITableView(frame: CGRect.zero, style: .grouped).apply {
		if #available(iOS 11.0, *) {
			$0.contentInsetAdjustmentBehavior = .never
		}
	}
	
    internal var setting: ALMenuTableViewCellSetting {
        ALMenuTableViewCellSetting()
    }
    
	
	internal var sections: [[String: SectionData]] {
        []
	}
	
    override init(title: String, isSloppySwipe: Bool, swipeTabViewController: ALSwipeTabViewController? = nil) {
		super.init(title: title, isSloppySwipe: isSloppySwipe, swipeTabViewController: swipeTabViewController)
		
        self.tableView.run {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.tableView.run {
            $0.frame = self.view.bounds
			$0.backgroundColor = .clear
        }
		
		self.view.addSubview(self.tableView)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableView.run {
            $0.frame = self.view.bounds
			$0.contentInset.top = self.contentInsetTop
			$0.scrollIndicatorInsets.top = self.contentInsetTop
		}
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
}

extension ALMenuViewController {	
	internal func deselectRow() {
		guard let indexPath = self.tableView.indexPathForSelectedRow else {
			return
		}
		
		self.tableView.deselectRow(at: indexPath, animated: true)
	}
}

extension ALMenuViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.sections.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard case let .String(header)? = self.sections[section]["header"] else {
            return ""
		}
        
        return header
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case let .Array(contents)? = self.sections[section]["contents"] else {
            return 0
		}
        
        return contents.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell").apply {
            $0.accessoryType = .disclosureIndicator
        }
        
        guard case let .Array(contents)? = self.sections[indexPath.section]["contents"] else {
            return cell
        }
        
        guard case let .Dictionary(content) = contents[indexPath.row] else {
            return cell
        }
        
        if case let .String(label)? = content["label"] {
            cell.textLabel?.text = label
            cell.textLabel?.font = self.setting.font
            cell.textLabel?.textColor = self.setting.color
        }
        
        if case let .String(text)? = content["detail"] {
            cell.detailTextLabel?.text = text
            cell.detailTextLabel?.textAlignment = .right
            cell.detailTextLabel?.font = self.setting.font
        }
		
		return cell
	}
}

extension ALMenuViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .Array(contents)? = self.sections[indexPath.section]["contents"] else {
            return
        }
        
        guard case let .Dictionary(content) = contents[indexPath.row] else {
            return
        }
        
        if case let .Closure(method)? = content["method"] {
            method(tableView, indexPath)
        }
	}
}
