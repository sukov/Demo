//
//  MainAssembly.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import UIKit

class MainAssembly {
	static var sharedInstance = MainAssembly()

	// Root
	func getRootController() -> UIViewController {
		let rController = UserManager.sharedInstance.isLoggedIn() ? MainAssembly.sharedInstance.getLeftMenuContainerController() : MainAssembly.sharedInstance.getLoginController()
		return rController

	}

	// Login
	func getLoginPresenter() -> LoginPresenter {
		return LoginPresenterImp()
	}

	func getLoginController() -> LoginController {
		return LoginController(presenter: MainAssembly.sharedInstance.getLoginPresenter())
	}

	// LeftMenu
	func getLeftMenuController() -> LeftMenuController {
		return LeftMenuController()
	}

	func getLeftMenuContainerController() -> LeftMenuContainerController {
		let controller = LeftMenuContainerController(
			rearViewController: MainAssembly.sharedInstance.getLeftMenuController(),
			frontViewController: MainAssembly.sharedInstance.getPostFeedController(.Hot))
		return controller
	}

	// PostFeed
	func getPostFeedPresenter(postType: PostsType) -> PostFeedPresenter {
		return PostFeedPresenterImp(postType: postType)
	}

	func getPostFeedController(postType: PostsType) -> UIViewController {
		return UINavigationController(rootViewController: PostFeedController(presenter: MainAssembly.sharedInstance.getPostFeedPresenter(postType)))
	}

	// ZoomPhoto
	func getZoomPhotoPresenter(imageUrl: NSURL, imageSize: CGSize) -> ZoomPhotoPresenter {
		return ZoomPhotoPresenterImp(imageUrl: imageUrl, imageSize: imageSize)
	}

	func getZoomPhotoController(imageUrl: NSURL, imageSize: CGSize) -> ZoomPhotoController {
		let presenter = getZoomPhotoPresenter(imageUrl, imageSize: imageSize)
		return ZoomPhotoController(presenter: presenter)
	}

	// CreatePost
	func getCreatePostPresenter() -> CreatePostPresenter {
		return CreatePostPresenterImp()
	}

	func getCreatePostController() -> CreatePostController {
		return CreatePostController(presenter: MainAssembly.sharedInstance.getCreatePostPresenter())
	}
}