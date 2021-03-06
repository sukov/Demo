//
//  SettingsController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/22/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

import UIKit

class SettingsController: BaseViewController {
	private var presenter: SettingsPresenter
	private var syncSwitch: UISwitch!
	private var syncLabel: UILabel!
	private var logoutButton: UIButton!

	init(presenter: SettingsPresenter) {
		self.presenter = presenter
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		presenter.attachView(self)
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		presenter.detachView(self)
	}

	override func setupViews() {
		super.setupViews()

		view.backgroundColor = UIColor.whiteColor()

		syncSwitch = UISwitch()
		syncSwitch.addTarget(presenter, action: #selector(presenter.syncSwitched(_:)), forControlEvents: .ValueChanged)

		syncLabel = UILabel()
		syncLabel.text = "Sync"

		logoutButton = UIButton()
		logoutButton.customBlueButton("Logout")
		logoutButton.addTarget(presenter, action: #selector(presenter.logOut), forControlEvents: .TouchUpInside)

		view.addSubview(syncSwitch)
		view.addSubview(syncLabel)
		view.addSubview(logoutButton)
	}

	override func setupConstraints() {
		super.setupConstraints()

		syncSwitch.snp_makeConstraints { (make) in
			make.left.top.equalTo(self.view).offset(80)
		}

		syncLabel.snp_makeConstraints { (make) in
			make.left.equalTo(syncSwitch.snp_right).offset(5)
			make.top.equalTo(syncSwitch.snp_top)
			make.width.equalTo(60)
		}

		logoutButton.snp_makeConstraints { (make) in
			make.top.equalTo(syncSwitch.snp_bottom).offset(60)
			make.left.right.equalTo(self.view)
			make.height.equalTo(40)
		}
	}
}

extension SettingsController: SettingsView {
	func showLoginPage() {
		presentViewController(MainAssembly.sharedInstance.getLoginController(), animated: true, completion: nil)
	}

	func setSwitch(value: Bool) {
		syncSwitch.setOn(value, animated: false)
	}
}