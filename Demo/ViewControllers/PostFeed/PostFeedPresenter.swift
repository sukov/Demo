//
//  PostFeedPresenter.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/5/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

protocol PostFeedPresenter {
	func attachView(view: PostFeedView)
	func detachView(view: PostFeedView)
	func refreshData()
	func loadNew()
	func retryUpload()
}
