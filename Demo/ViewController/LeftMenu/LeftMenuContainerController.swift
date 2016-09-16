//
//  LeftMenuContainerController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/16/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

class LeftMenuContainerController: SWRevealViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		revealViewController()
		view.addGestureRecognizer(self.panGestureRecognizer())
		rearViewRevealWidth = UIScreen.mainScreen().bounds.width / 1.5
		rearViewRevealOverdraw = 0
		view.backgroundColor = UIColor.whiteColor()
	}
}
