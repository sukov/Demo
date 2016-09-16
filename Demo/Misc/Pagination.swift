//
//  Pagination.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/7/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

class Pagination {
	private var pageNum: Int

	init() {
		pageNum = 1
	}

	func nextPage() {
		pageNum += 1
	}

	func getPageNumber() -> Int {
		return pageNum
	}

	func resetPageNumber() {
		pageNum = 1
	}
}