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
	private var pagination = Pagination()
	private var posts: [[String: AnyObject]]

	init(postType: PostsType) {
		self.postType = postType
		posts = []
		addObservers()
	}

	deinit {
		removeObservers()
	}

	func getposts(complete: () -> Void) {
		NetworkManager.sharedInstance.getPosts(postType, pageNumber: pagination.getPageNumber()) { [weak self](posts, error) in
			if (error == nil) {
				self?.pagination.connectionIsON()
				if let _posts = posts, _self = self {
					if (_self.pagination.getPageNumber() == 0) {
						_self.posts = []
						CacheManager.sharedInstance.clearCachedPosts(_self.postType)
						SDWebImageManager.sharedManager().imageCache?.cleanDisk()
						_self.posts.appendContentsOf(_posts)
						complete()
						_self.view?.showPosts(_self.posts)
						_self.view?.scrollToTop()
					} else {
						_self.posts.appendContentsOf(_posts)
						complete()
						_self.view?.showPosts(_self.posts)
					}
					CacheManager.sharedInstance.cachePosts(_posts, type: _self.postType)
				}
			} else {
				if (error?.code == ErrorNumbers.connection) {
					self?.pagination.connectionIsOFF()
					if posts != nil {
						complete()
						return
					}
					if let _self = self, _posts = CacheManager.sharedInstance.getCachedPosts(_self.postType) {
						complete()
						_self.view?.showPosts(_posts)
					}
				}
			}
			complete()
		}
	}

	func addObservers() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshData), name: UIApplicationWillEnterForegroundNotification, object: UIApplication.sharedApplication())

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(uploadFailed(_:)), name: NotificationKeys.uploadFailed, object: nil)
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
		} else {
			view?.showRetryAlert()
			AlertFactory.retryActionClosure = { [weak self] in
				self?.retryUpload()
			}
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
		pagination.nextPage()
		getposts { [weak self] in
			self?.view?.stopAnimating()
		}
	}

	@objc func refreshData() {
		pagination.resetPageNumber()
		getposts { [weak self] in
			self?.view?.stopRefreshing()
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