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
	private var syncLabel: UILabel!
	private var logoutButton: UIButton!

	init(presenter: SettingsPresenter) {
		self.presenter = presenter
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

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		presenter.attachView(self)
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		presenter.detachView(self)
	}

	func setupViews() {
		view.backgroundColor = UIColor.whiteColor()
		syncSwitch = UISwitch()
		syncLabel = UILabel()
		logoutButton = UIButton()
		syncLabel.text = "Sync"
		logoutButton.customBlueButton("Logout")

		view.addSubview(syncSwitch)
		view.addSubview(syncLabel)
		view.addSubview(logoutButton)
	}

	func setupConstraints() {
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

}