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
	private var images: [[String: AnyObject]]

	init(postType: PostsType) {
		self.postType = postType
		images = []
		addObservers()
	}

	deinit {
		removeObservers()
	}

	func getImages(complete: () -> Void) {
		NetworkManager.sharedInstance.getPosts(postType, pageNumber: pagination.getPageNumber()) { [weak self](images, error) in
			if (error == nil) {
				self?.pagination.connectionIsON()
				if let _images = images, _self = self {
					print(_images.count)
					if (_self.pagination.getPageNumber() == 0) {
						_self.images = []
						CacheManager.sharedInstance.clearCachedPosts(_self.postType)
						SDWebImageManager.sharedManager().imageCache?.cleanDisk()
						_self.images.appendContentsOf(_images)
						complete()
						_self.view?.showPictures(_self.images)
						_self.view?.scrollToTop()
					} else {
						_self.images.appendContentsOf(_images)
						complete()
						_self.view?.showPictures(_self.images)
					}
					CacheManager.sharedInstance.cachePosts(_images, type: _self.postType)
				}
			} else {
				if (error?.code == -1009) {
					self?.pagination.connectionIsOFF()
					if images != nil {
						complete()
						return
					}
					if let _self = self, _images = CacheManager.sharedInstance.getCachedPosts(_self.postType) {
						complete()
						_self.view?.showPictures(_images)
					}
				}
			}
			complete()
		}
	}

	func addObservers() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(uploadFailed), name: NotificationKeys.uploadFailed, object: nil)
	}

	func removeObservers() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	@objc func uploadFailed() {
		view?.showAlert()
	}
}

extension PostFeedPresenterImp: PostFeedPresenter {

	func attachView(view: PostFeedView) {
		if (self.view == nil) {
			self.view = view
		}
	}

	func detachView(view: PostFeedView) {
		if (self.view === view) {
			self.view = nil
		}
	}

	func loadNew() {
		view?.startAnimating()
		pagination.nextPage()
		getImages { [weak self] in
			self?.view?.stopAnimating()
		}
	}

	func refreshData() {
		pagination.resetPageNumber()
		getImages { [weak self] in
			self?.view?.stopRefreshing()
		}

	}

	func retryUpload() {
		NetworkManager.sharedInstance.retryLastUpload { (success) in
			if (success) {
				LocalNotificationsManager.sharedInstance.displaySuccess()
			} else {
				LocalNotificationsManager.sharedInstance.displayFailure()
			}
		}
	}
}