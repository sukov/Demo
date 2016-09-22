//
//  LoginController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/2/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//
import UIKit
import SnapKit

class LoginController: UIViewController {
	private var presenter: LoginPresenter
	private var imgurImageView: UIImageView!
	private var loginButton: UIButton!

	init(presenter: LoginPresenter) {
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
		imgurImageView = UIImageView()
		loginButton = UIButton()

		view.backgroundColor = UIColor.whiteColor()
		imgurImageView.image = UIImage(named: "imgurLogo")
		loginButton.customBlueButton("Login with imgur")
		loginButton.addTarget(presenter, action: #selector(LoginPresenter.login), forControlEvents: .TouchUpInside)

		view.addSubview(imgurImageView)
		view.addSubview(loginButton)
	}

	func setupConstraints() {
		imgurImageView.snp_makeConstraints { (make) in
			make.width.equalTo(150)
			make.height.equalTo(70)
			make.top.equalTo(150)
			make.left.equalTo(self.view.snp_right).dividedBy(3)
		}

		loginButton.snp_makeConstraints { (make) in
			make.width.equalTo(150)
			make.height.equalTo(40)
			make.top.equalTo(imgurImageView.snp_bottom).offset(20)
			make.left.equalTo(imgurImageView.snp_left)
		}
	}
}

extension LoginController: LoginView {

}
