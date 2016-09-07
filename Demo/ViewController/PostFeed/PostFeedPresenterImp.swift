//
//  PostFeedPresenterImp.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/5/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

enum FeedType {
	case Hot
	case Popular
	case User
}

class PostFeedPresenterImp {
	weak private var view: PostFeedView?
	private var feed: FeedType
	private var pagination = Pagination()
	private var images: [[String: AnyObject]]

	init(feed: FeedType) {
		self.feed = feed
		images = []
	}

	func getImages(complete: () -> Void) {
		switch feed {
		case .Hot:
			NetworkManager.sharedInstance.getHotImages(UserManager.sharedInstance.user!.accessToken, pageNumber: pagination.getPageNumber(), complete: { [weak self](images, error) in
				if (error == nil) {
					self?.images.appendContentsOf(images!)
					complete()
					self?.view?.showPictures(self!.images)
				}
			})
		case .Popular:
			NetworkManager.sharedInstance.getPopularImages((UserManager.sharedInstance.user?.accessToken)!, pageNumber: pagination.getPageNumber(), complete: { [weak self](images, error) in
				if (error == nil) {
					self?.images.appendContentsOf(images!)
					complete()
					self?.view?.showPictures(self!.images) }
			})
		case .User:
			NetworkManager.sharedInstance.getUserImages(UserManager.sharedInstance.user!.userName, token: UserManager.sharedInstance.user!.accessToken, pageNumber: pagination.getPageNumber(), complete: { [weak self](images, error) in
				if (error == nil) {
					self?.images.appendContentsOf(images!)
					complete()
					self?.view?.showPictures(self!.images)
				}
			})
		}
	}
}

extension PostFeedPresenterImp: PostFeedPresenter {

	func attachView(view: PostFeedView) {
		if (self.view == nil) {
			self.view = view
			getImages { }
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
		images = []
		pagination.resetPageNumber()
		getImages { [weak self] in
			self?.view?.stopRefreshing()
		}

	}
}