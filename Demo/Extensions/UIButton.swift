//
//  UIButton.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/22/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import Foundation

extension UIButton {
	func customBlueButton(title: String) {
		backgroundColor = UIColor.blueColor()
		setTitle(title, forState: .Normal)
		setTitleColor(UIColor.whiteColor(), forState: .Normal)
	}
}