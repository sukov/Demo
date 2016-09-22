//
//  Pagination.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/7/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

class Pagination {
	private var pageNum: Int
	private var isConnectionOn: Bool

	init() {
		pageNum = 0
		isConnectionOn = true
	}

	func nextPage() {
		if (isConnectionOn) {
			pageNum += 1
		}
	}

	func getPageNumber() -> Int {
		return pageNum
	}

	func resetPageNumber() {
		pageNum = 0
	}

	func connectionIsOFF() {
		isConnectionOn = false
		resetPageNumber()
	}

	func connectionIsON() {
		isConnectionOn = true
	}
}