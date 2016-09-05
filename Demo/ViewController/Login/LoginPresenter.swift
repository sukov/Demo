//
//  LoginPresenter.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

@objc protocol LoginPresenter {
	func attachView(view: LoginView)
	func detachView(view: LoginView)
	func login()
}
