//
//  SettingsView.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/22/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

@objc protocol SettingsView {
	func showLoginPage()
	func setSwitch(value: Bool)
}