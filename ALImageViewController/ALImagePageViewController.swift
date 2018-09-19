import UIKit
import SwiftyJSON
import Photos
import AssetsLibrary

class ALImagePageViewController: UIPageViewController {
	private let Padding = 16.0
	
	fileprivate let urls: [URL]
	
	var count: Int {
		return self.urls.count
	}
	
	fileprivate(set) var index = 0
	
	init(urls: [URL]) {
		self.urls = urls
		
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: self.Padding])
		
		self.dataSource = self
		self.delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	func next() {
		if self.index < self.urls.count - 1 {
			self.index += 1
			self.refreshPageNumber()
			
			let viewController = ALScrollImageViewController(url: self.urls[self.index]).apply {
				$0.view.tag = self.index
			}
			
			self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
		}
	}
	
	func previous() {
		if self.index > 0 {
			self.index -= 1
			self.refreshPageNumber()
			
			let viewController = ALScrollImageViewController(url: self.urls[self.index]).apply {
				$0.view.tag = self.index
			}
			
			self.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
		}
	}
	
	func setImageIndex(_ index: Int) -> Bool {
		self.index = index
		
		if self.index < self.urls.count {
			let url = self.urls[self.index]
			
			let viewController = ALScrollImageViewController(url: url).apply {
				$0.view.tag = self.index
			}
			
			self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
			
			self.refreshPageNumber()
			
			return true
		} else {
			print("画像表示失敗")
			
			return false
		}
	}
	
	func refreshPageNumber() {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "\(self.index + 1)  /  \(self.urls.count)", style:.plain, target: self, action: nil)
		
		self.navigationController?.setToolbarHidden(false, animated: true)
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	func saveOne(done: ((_ url: URL) -> Void)? = nil) {
		let url = self.urls[self.index]
		
		URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in		
			guard let data = data else {
				return
			}

			guard let urlTemp = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("tmp.gif") else {
				return
			}
			
			do {
				try data.write(to: urlTemp, options: .atomic)
			} catch {
				print(error)
			}
			
			self.saveFiles([urlTemp], done: { _ in
				done?(url)
			})
		}).resume()
	}
	
	func saveAll(done: (() -> Void)? = nil) {
		var spinLock = OS_SPINLOCK_INIT
		var paths = [URL]()
		
		for (i, url) in self.urls.enumerated() {
			print(url)
			
			URLSession.shared.dataTask(with: url as URL, completionHandler: { data, response, error in				
				OSSpinLockLock(&spinLock)
				
				guard let pathTemp = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("tmp\(i).gif") else {
					return
				}
				
				guard let data = data else {
					return
				}
				
//				guard (try? data.write(to: pathTemp, options: .atomic)) != nil else {
//					return
//				}
				
				do {
					try data.write(to: pathTemp, options: .atomic)
				} catch {
					print(error)
				}
				
				paths.append(pathTemp)
				
				print("\(i):\(paths.count)")
				
				if paths.count == self.urls.count {
					self.saveFiles(paths, done: { _ in
						done?()
					})
				}
				
				OSSpinLockUnlock(&spinLock)
			}).resume()
		}
	}
	
	private func saveFiles(_ paths: [URL], done: (() -> Void)? = nil) {
		let list = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: nil)
		
		var assetAlbum: PHAssetCollection?
		
		list.enumerateObjects({ album, index, isStop in
			if album.localizedTitle == AppParameter.AlbumName {
				assetAlbum = album 
				isStop.pointee = true
			}
		})
		
		if let album = assetAlbum {
			PHPhotoLibrary.shared().performChanges({
				var assetPlaceholder = [PHObjectPlaceholder]()
				
				for pathTemp in paths {
					guard let result = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: pathTemp) else {
						continue
					}
					
					guard let placeholderForCreatedAsset = result.placeholderForCreatedAsset else {
						continue
					}
					
					assetPlaceholder.append(placeholderForCreatedAsset)
				}
				
				PHAssetCollectionChangeRequest(for: album)?.run {
					$0.addAssets(assetPlaceholder as NSFastEnumeration)
				}
			}, completionHandler: { success, error in
				print("Finished deleting asset.")
				print(success)
	
				if let error = error {
					print(error)
					
					if error._code == 2047 {
						self.openSetting()
					}
					
					return
				}
				
				done?()
			})
		} else {
			PHPhotoLibrary.shared().performChanges({
				PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: AppParameter.AlbumName)
			}, completionHandler: { success, error in
				print(success)
				
				if let error = error {
					print(error)
					
					if error._code == 2047 {
						self.openSetting()
					}
					
					return
				}
				
				print("アルバム作成完了")
				
				self.saveFiles(paths, done: done)
			})
		}
	}
	
	func openSetting() {
		let title = "画像の保存に失敗しました"
		let message = "設定画面を開きます。写真へのアクセスを許可してから再度保存してください。"		
		
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert).apply {
			let ok = UIAlertAction(title: "はい", style: .default, handler: { action in
				guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
					return
				}
				
				UIApplication.shared.openURL(url)
			})
			let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

			$0.addAction(ok)
			$0.addAction(cancel)
		}
		
		self.present(alertController, animated: true, completion: nil)
	}
}

extension ALImagePageViewController : UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let scrollImageViewController = viewController as? ALScrollImageViewController else {
			return nil
		}
		
		let index = scrollImageViewController.view.tag
		
		if index > 0 {
			return ALScrollImageViewController(url: self.urls[index - 1]).apply {
				$0.view.tag = index - 1
			}
		} else {
			return nil
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let scrollImageViewController = viewController as? ALScrollImageViewController else {
			return nil
		}
		
		let index = scrollImageViewController.view.tag
		
		if index < self.urls.count - 1 {
			return ALScrollImageViewController(url: self.urls[index + 1]).apply {
				$0.view.tag = index + 1
			}
		} else {
			return nil
		}
	}
}

extension ALImagePageViewController: UIPageViewControllerDelegate {
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		guard let scrollImageViewController = pageViewController.viewControllers?.first as? ALScrollImageViewController else {
			return
		}
		
		self.index = scrollImageViewController.view.tag
		
		self.refreshPageNumber()
	}
}