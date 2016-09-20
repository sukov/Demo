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
		usernameLabel.sizeToFit()
		settingsButton.setImage(UIImage(named: "gearIcon"), forState: .Normal)
		settingsButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
		hotPostsButton.setTitle("Hot posts", forState: .Normal)
		hotPostsButton.backgroundColor = UIColor.blueColor()
		popularPostsButton.setTitle("Popular posts", forState: .Normal)
		popularPostsButton.backgroundColor = UIColor.blueColor()
		userPostsButton.setTitle("User posts", forState: .Normal)
		userPostsButton.backgroundColor = UIColor.blueColor()
		hotPostsButton.addTarget(self, action: #selector(hotPostsButtonTapped), forControlEvents: .TouchUpInside)
		popularPostsButton.addTarget(self, action: #selector(popularPostsButtonTapped), forControlEvents: .TouchUpInside)
		userPostsButton.addTarget(self, action: #selector(userPostsButtonTapped), forControlEvents: .TouchUpInside)

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

		hotPostsButton.snp_makeConstraints { (make) in
			make.top.equalTo(usernameLabel.snp_bottom).offset(20)
			make.left.right.equalTo(self.view)
			make.height.equalTo(40)
		}

		popularPostsButton.snp_makeConstraints { (make) in
			make.top.equalTo(hotPostsButton.snp_bottom).offset(10)
			make.left.right.equalTo(self.view)
			make.height.equalTo(40)
		}

		userPostsButton.snp_makeConstraints { (make) in
			make.top.equalTo(popularPostsButton.snp_bottom).offset(10)
			make.left.right.equalTo(self.view)
			make.height.equalTo(40)
		}
	}

	func setContent() {
		profileImageView.layoutIfNeeded()
		profileImageView.sd_setImageWithURL(NSURL(
			string: "https://thenypost.files.wordpress.com/2015/08/spongebob-e1441057213584.jpg?quality=90&strip=all&w=664&h=441&crop=1")!)
		usernameLabel.text = UserManager.sharedInstance.user?.userName
	}

	func hotPostsButtonTapped() {
		revealViewController().pushFrontViewController(MainAssembly.sharedInstance.getPostFeedController(.Hot), animated: true)
	}

	func popularPostsButtonTapped() {
		revealViewController().pushFrontViewController(MainAssembly.sharedInstance.getPostFeedController(.Popular), animated: true)
	}

	func userPostsButtonTapped() {
		revealViewController().pushFrontViewController(MainAssembly.sharedInstance.getPostFeedController(.User), animated: true)
	}
}
