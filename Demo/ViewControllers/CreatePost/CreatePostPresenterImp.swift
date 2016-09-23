//
//  CreatePostPresenterImp.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/12/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import UIKit

class CreatePostPresenterImp {
	weak private var view: CreatePostView?
}

extension CreatePostPresenterImp: CreatePostPresenter {
	@objc func attachView(view: CreatePostView) {
		if (self.view == nil) {
			self.view = view
		}

	}

	@objc func detachView(view: CreatePostView) {
		if (self.view === view) {
			self.view = nil
		}
	}

	@objc func postSubmit(image: UIImage, title: String, description: String) {
		NetworkManager.sharedInstance.uploadImage(image, title: title, description: description, complete: { error in
			if (error == nil) {
				LocalNotificationsManager.sharedInstance.displaySuccess()
			} else {
				LocalNotificationsManager.sharedInstance.displayFailure()
			}
		})
	}
}