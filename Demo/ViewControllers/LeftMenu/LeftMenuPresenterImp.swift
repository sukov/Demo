//
//  LeftMenuPresenterImp.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/30/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class LeftMenuPresenterImp {
	weak private var view: LeftMenuView?

}

extension LeftMenuPresenterImp: LeftMenuPresenter {
	func attachView(view: LeftMenuView) {
		if (self.view == nil) {
			self.view = view
			NSNotificationCenter.defaultCenter().addObserver(view,
				selector: #selector(view.showUserPosts),
				name: NotificationKeys.showUserPosts,
				object: nil)

		}
	}

	func detachView(view: LeftMenuView) {
		if (self.view === view) {
			self.view = nil
			NSNotificationCenter.defaultCenter().removeObserver(view)
		}
	}
}