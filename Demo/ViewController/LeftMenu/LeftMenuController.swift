//
//  LeftMenuController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/16/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

class LeftMenuController: UIViewController {
	private var profileImageView: UIImageView!
	private var usernameLabel: UILabel!
	private var settingsButton: UIButton!
	private var hotPostsButton: UIButton!
	private var popularPostsButton: UIButton!
	private var userPostsButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
		setContent()
	}

	func setupViews() {
		profileImageView = UIImageView()
		usernameLabel = UILabel()
		settingsButton = UIButton()
		hotPostsButton = UIButton()
		popularPostsButton = UIButton()
		userPostsButton = UIButton()
		view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
		profileImageView.backgroundColor = UIColor.redColor()
		usernameLabel.sizeToFit()
		settingsButton.setImage(UIImage(named: "gearIcon"), forState: .Normal)
		settingsButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit

		view.addSubview(profileImageView)
		view.addSubview(usernameLabel)
		view.addSubview(settingsButton)
		view.addSubview(hotPostsButton)
		view.addSubview(popularPostsButton)
		view.addSubview(userPostsButton)
	}

	func setupConstraints() {
		profileImageView.snp_makeConstraints { (make) in
			let imageHeight = (UIScreen.mainScreen().bounds.width / 1.5) / 1.7
			make.top.equalTo(20)
			make.left.equalTo(self.view.snp_left).offset(5)
			make.right.equalTo(self.view.snp_right).offset(-5)
			make.height.equalTo(imageHeight)
		}

		usernameLabel.snp_makeConstraints { (make) in
			make.left.equalTo(profileImageView.snp_left)
			make.top.equalTo(profileImageView.snp_bottom).offset(10)
		}

		settingsButton.snp_makeConstraints { (make) in
			make.right.equalTo(profileImageView.snp_right)
			make.top.equalTo(profileImageView.snp_bottom).offset(5)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}

	}

	func setContent() {
		profileImageView.layoutIfNeeded()
		profileImageView.hnk_setImageFromURL(NSURL(
			string: "https://thenypost.files.wordpress.com/2015/08/spongebob-e1441057213584.jpg?quality=90&strip=all&w=664&h=441&crop=1")!)
		usernameLabel.text = UserManager.sharedInstance.user?.userName
	}
}
