import UIKit
import NotificationCenter

class ALTodayArticleViewController : UIViewController {
	internal let tableView = UITableView()
	
	internal var articles = [ALArticle]()
	
    internal var separatorInset: UIEdgeInsets? {
        nil
    }
    
    internal var cell: ALArticleTableViewCell {
        let setting = ALArticleTableViewCellSetting()
        
        return tableView.dequeueReusableCell(withIdentifier: setting.reuseIdentifier) as? ALArticleTableViewCell ?? ALArticleTableViewCell(setting: setting)
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.run {
			$0.delegate = self
			$0.dataSource = self
			$0.cellLayoutMarginsFollowReadableWidth = false
            
            if let separatorInset = self.separatorInset {
                $0.separatorInset = separatorInset
            }
		}
		
		self.view.addSubview(self.tableView)
		
		if #available(iOSApplicationExtension 10.0, *) {
			self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
        self.tableView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.getCellHeight(width: self.view.frame.width) * 5)
	}
	
	func load(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
	}
	
    func getCellHeight(width: CGFloat) -> CGFloat {
        return ALArticleTableViewCellSetting().height(width: width)
    }
    
	func open(alArticle: ALArticle) {
	}
}

extension ALTodayArticleViewController: NCWidgetProviding {
	@available(iOSApplicationExtension 10.0, *)
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		print(#function)
		
		if activeDisplayMode == .compact {
			self.preferredContentSize = maxSize
		} else {
			self.preferredContentSize = CGSize(width: 0, height: self.getCellHeight(width: self.view.frame.width) * 5)
		}
		
		self.tableView.reloadData()
	}
	
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		print(#function)
        
        self.load(completionHandler: completionHandler)
	}
}

extension ALTodayArticleViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		if #available(iOSApplicationExtension 10.0, *) {
//			if self.extensionContext?.widgetActiveDisplayMode == .expanded {
//				return self.cells.count
//			} else {
//				if self.cells.count > 0 {
//					return 1
//				} else {
//					return self.cells.count
//				}
//			}
//		}
		
		return self.articles.count
	}
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = self.articles[indexPath.row]
        
        return self.cell.apply {
            $0.alArticle = article
        }
    }
    
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.getCellHeight(width: self.view.frame.width)
	}
}

extension ALTodayArticleViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let article = self.articles[indexPath.row]
		
		self.open(alArticle: article)
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
