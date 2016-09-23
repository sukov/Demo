//
//  SettingsController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/22/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
	private var presenter: SettingsPresenter
	private var syncSwitch: UISwitch!
	private var logoutButton: UIButton!

	init(presenter: SettingsPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension SettingsController: SettingsView {

}