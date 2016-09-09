//
//  ZoomPhotoPresenter.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/9/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

protocol ZoomPhotoPresenter {
	func attachView(view: ZoomPhotoView)
	func detachView(view: ZoomPhotoView)
}