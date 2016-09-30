//
//  BaseViewController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/28/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

class BaseViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
	}

	func setupViews() {

	}

	func setupConstraints() {

	}
}
