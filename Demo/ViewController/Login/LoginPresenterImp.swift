//
//  LoginPresenterImp.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import Alamofire

class LoginPresenterImp {
	weak private var view: LoginView?
}

extension LoginPresenterImp: LoginPresenter {
	@objc func attachView(view: LoginView) {
		if (self.view == nil) {
			self.view = view
		}
	}

	@objc func detachView(view: LoginView) {
		if (self.view === view) {
			self.view = nil
		}
	}

	@objc func login() {
		NetworkManager.sharedInstance.requestToken()
	}
}