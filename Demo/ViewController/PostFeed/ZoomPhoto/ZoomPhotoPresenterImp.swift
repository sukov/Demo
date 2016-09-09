//
//  ZoomPhotoPresenterImp.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/9/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class ZoomPhotoPresenterImp {
	weak private var view: ZoomPhotoView?
	private var image: [String: AnyObject]

	init(image: [String: AnyObject]) {
		self.image = image
	}
}

extension ZoomPhotoPresenterImp: ZoomPhotoPresenter {
	func attachView(view: ZoomPhotoView) {
		if (self.view == nil) {
			self.view = view
			view.showPicture(image)
		}
	}

	func detachView(view: ZoomPhotoView) {
		if (self.view === view) {
			self.view = nil
		}
	}
}