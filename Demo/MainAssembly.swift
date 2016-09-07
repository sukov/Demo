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
		let rController = UserManager.sharedInstance.isLoggedIn() ? MainAssembly.sharedInstance.getPostFeedController() : MainAssembly.sharedInstance.getLoginController()
		return rController
	}

	// Login
	func getLoginPresenter() -> LoginPresenter {
		return LoginPresenterImp()
	}

	func getLoginController() -> LoginController {
		return LoginController(presenter: MainAssembly.sharedInstance.getLoginPresenter())
	}

	// PostFeed
	func getPostFeedPresenter() -> PostFeedPresenter {
		return PostFeedPresenterImp(feed: .Popular)
	}

	func getPostFeedController() -> PostFeedController {
		return PostFeedController(presenter: MainAssembly.sharedInstance.getPostFeedPresenter())
	}

}