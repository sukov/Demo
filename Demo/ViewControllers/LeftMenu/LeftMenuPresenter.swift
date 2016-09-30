//
//  LeftMenuPresenter.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/30/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

protocol LeftMenuPresenter {
	func attachView(view: LeftMenuView)
	func detachView(view: LeftMenuView)
}