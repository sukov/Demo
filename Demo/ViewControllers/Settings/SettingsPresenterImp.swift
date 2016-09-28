//
//  SettingsPresenterImp.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/22/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import SDWebImage

class SettingsPresenterImp {
	weak private var view: SettingsView?
}

extension SettingsPresenterImp: SettingsPresenter {
	@objc func attachView(view: SettingsView) {
		if (self.view == nil) {
			self.view = view
			view.setSwitch(CacheManager.sharedInstance.isCachingON())
		}
	}

	@objc func detachView(view: SettingsView) {
		if (self.view === view) {
			self.view = nil
		}
	}

	@objc func logOut() {
		CacheManager.sharedInstance.clearAllCache()
		CoreDataManager.sharedInstance.removeAllPosts()
		SDWebImageManager.sharedManager().imageCache?.clearMemory()
		SDWebImageManager.sharedManager().imageCache?.clearDisk()
		UserManager.sharedInstance.removeUser()
		TokenProvider.sharedInstance.removeToken()
		NetworkManager.sharedInstance.cancelAllRequests()
		view?.showLoginPage()
	}

	@objc func syncSwitched(sender: UISwitch) {
		if (sender.on) {
			CacheManager.sharedInstance.setCachingON()
		} else {
			CacheManager.sharedInstance.setCachingOFF()
		}
	}
}