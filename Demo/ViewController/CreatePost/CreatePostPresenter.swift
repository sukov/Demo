//
//  CreatePostPresenter.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/12/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
import Foundation
import UIKit

@objc protocol CreatePostPresenter {
	func attachView(view: CreatePostView)
	func detachView(view: CreatePostView)
	func postSubmit(image: UIImage, title: String, description: String)
}
