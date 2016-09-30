//
//  PostFeedPresenterImp.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/5/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
import Foundation
import SDWebImage

enum PostsType: String {
	case Hot
	case Popular
	case User
}

class PostFeedPresenterImp {
	weak private var view: PostFeedView?
	private var postType: PostsType
	private var pagination: Int = 0
	private var posts: [[String: AnyObject]]
	private var lastTryConnection: Bool = true

	init(postType: PostsType) {
		self.postType = postType
		posts = []
		loadDiscCache()
		addObservers()
	}

	deinit {
		if (posts.count > 0) {
			CoreDataManager.sharedInstance.savePostsByType(posts, type: postType)
		}
		removeObservers()
	}

	private func loadDiscCache() {
		if let savedCache = CoreDataManager.sharedInstance.getPostsByType(postType) {
			CacheManager.sharedInstance.updateCacheForType(savedCache, type: postType)
		}
	}

	func getPosts(complete: () -> Void) {
		NetworkManager.sharedInstance.getPosts(postType, pageNumber: pagination) { [weak self](posts, error) in
			if (error == nil) {
				self?.lastTryConnection = true
				if let _posts = posts, _self = self {
					if (_self.pagination == 0) {
						_self.posts = []
						CacheManager.sharedInstance.clearPostsByType(_self.postType)
						CoreDataManager.sharedInstance.removePostsByType(_self.postType)
						SDWebImageManager.sharedManager().imageCache?.cleanDisk()
						_self.posts.appendContentsOf(_posts)
						_self.view?.scrollToTop()
					} else {
						_self.posts.appendContentsOf(_posts)
					}
					CacheManager.sharedInstance.updateCacheForType(_posts, type: _self.postType)
				}
			} else {
				if (error?.code == ErrorNumbers.connection && CacheManager.sharedInstance.isCachingOn) {
					self?.lastTryConnection = false
					self?.pagination = 0
					if posts != nil {
						return
					}
					if let _self = self, _posts = CacheManager.sharedInstance.getCachedPostsByType(_self.postType) {
						_self.posts = _posts
					}
				} else if (error?.code >= 500 || error?.code < 0) {
					self?.view?.showLoginPage()
					UserManager.sharedInstance.removeUser()
					TokenProvider.sharedInstance.removeToken()
				}
			}
			complete()
		}
	}

	func addObservers() {
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: #selector(refreshData),
			name: UIApplicationWillEnterForegroundNotification,
			object: UIApplication.sharedApplication())

		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: #selector(uploadFailed(_:)),
			name: NotificationKeys.uploadFailed,
			object: nil)
	}

	func removeObservers() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	@objc func uploadFailed(sender: NSNotification) {
		if ((sender.userInfo?["error"] as? Int) == ErrorNumbers.connection) {
			view?.showSettingsAlert()
			AlertFactory.settingsActionClosure = { [weak self] in
				self?.view?.showRetryAlert()
			}
		} else if ((sender.userInfo?["error"] as? Int) >= 400 && (sender.userInfo?["error"] as? Int) <= 499) {
			view?.showRetryAlert()
			AlertFactory.retryActionClosure = { [weak self] in
				self?.retryUpload()
			}
		} else {
			view?.showLoginPage()
		}
	}
}

extension PostFeedPresenterImp: PostFeedPresenter {

	@objc func attachView(view: PostFeedView) {
		if (self.view == nil) {
			self.view = view
		}
	}

	@objc func detachView(view: PostFeedView) {
		if (self.view === view) {
			self.view = nil
		}
	}

	@objc func loadNew() {
		view?.startAnimating()
		if (lastTryConnection) {
			pagination += 1
		}
		getPosts { [weak self] in
			if let _self = self {
				_self.view?.showPosts(_self.posts)
				_self.view?.stopAnimating()
			}
		}
	}

	@objc func refreshData() {
		pagination = 0
		getPosts { [weak self] in
			if let _self = self {
				_self.view?.stopRefreshing()
				_self.view?.showPosts(_self.posts)
			}
		}
	}

	@objc func retryUpload() {
		NetworkManager.sharedInstance.retryLastUpload { (error) in
			if (error == nil) {
				LocalNotificationsManager.sharedInstance.displaySuccess()
			} else {
				LocalNotificationsManager.sharedInstance.displayFailure()
			}
		}
	}
}