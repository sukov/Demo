//
//  SettingsPresenterImp.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/22/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

class SettingsPresenterImp {
	weak private var view: SettingsView?

}

extension SettingsPresenterImp: SettingsPresenter {
	func attachView(view: SettingsView) {
		if (self.view == nil) {
			self.view = view
		}
	}

	func detachView(view: SettingsView) {
		if (self.view === view) {
			self.view = nil
		}
	}
}