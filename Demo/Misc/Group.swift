//
//  Group.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/15/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

enum GroupType: Int {
	case RefreshToken = 0
}

class Group {
	private var groups: [dispatch_group_t]

	static var sharedInstance = Group()

	init() {
		groups = []

		for _ in 0..<1 {
			groups.append(dispatch_group_create())
		}
	}

	func enter(groupType: GroupType) {
		dispatch_group_enter(groups[groupType.rawValue])
	}

	func leave(groupType: GroupType) {
		dispatch_group_leave(groups[groupType.rawValue])
	}

	func waitForGroupToFinnish(groupType: GroupType) {
		dispatch_group_wait(groups[groupType.rawValue], DISPATCH_TIME_FOREVER)
	}

}