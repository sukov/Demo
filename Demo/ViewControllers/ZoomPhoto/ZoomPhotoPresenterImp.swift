//
//  ZoomPhotoPresenterImp.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/9/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation
import UIKit

class ZoomPhotoPresenterImp {
	weak private var view: ZoomPhotoView?
	private var imageUrl: NSURL
	private var imageSize: CGSize

	init(imageUrl: NSURL, imageSize: CGSize) {
		self.imageUrl = imageUrl
		self.imageSize = imageSize
	}
}

extension ZoomPhotoPresenterImp: ZoomPhotoPresenter {
	func attachView(view: ZoomPhotoView) {
		if (self.view == nil) {
			self.view = view
			view.showImage(imageUrl, size: imageSize)
		}
	}

	func detachView(view: ZoomPhotoView) {
		if (self.view === view) {
			self.view = nil
		}
	}
}