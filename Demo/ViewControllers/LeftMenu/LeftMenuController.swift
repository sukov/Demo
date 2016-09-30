//
//  LeftMenuController.swift
//  Demo
//
//  Created by WF | Gorjan Shukov on 9/16/16.
//  Copyright © 2016 WF | Gorjan Shukov. All rights reserved.
//

class LeftMenuController: BaseViewController {
	private var profileImageView: UIImageView!
	private var usernameLabel: UILabel!
	private var settingsButton: UIButton!
	private var hotPostsButton: UIButton!
	private var popularPostsButton: UIButton!
	private var userPostsButton: UIButton!

	override init() {
		super.init()
		addObservers()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		removeObservers()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setContent()
	}

	override func setupViews() {
		super.setupViews()

		view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)

		profileImageView = UIImageView()
		usernameLabel = UILabel()
		usernameLabel.sizeToFit()
		settingsButton = UIButton()
		settingsButton.setImage(UIImage(named: ImageNames.gearIcon), forState: .Normal)
		settingsButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
		settingsButton.addTarget(self, action: #selector(settingsButtonTapped), forControlEvents: .TouchUpInside)
		hotPostsButton = UIButton()
		hotPostsButton.customBlueButton("Hot posts")
		hotPostsButton.addTarget(self, action: #selector(hotPostsButtonTapped), forControlEvents: .TouchUpInside)
		popularPostsButton = UIButton()
		popularPostsButton.customBlueButton("Popular posts")
		popularPostsButton.addTarget(self, action: #selector(popularPostsButtonTapped), forControlEvents: .TouchUpInside)
		userPostsButton = UIButton()
		userPostsButton.customBlueButton("User posts")
		userPostsButton.addTarget(self, action: #selector(userPostsButtonTapped), forControlEvents: .TouchUpInside)

		view.addSubview(profileImageView)
		view.addSubview(usernameLabel)
		view.addSubview(settingsButton)
		view.addSubview(hotPostsButton)
		view.addSubview(popularPostsButton)
		view.addSubview(userPostsButton)
	}

	override func setupConstraints() {
		super.setupConstraints()

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

	// This goes to Presenter
	func setContent() {
		profileImageView.sd_setImageWithURL(NSURL(
			string: "https://thenypost.files.wordpress.com/2015/08/spongebob-e1441057213584.jpg?quality=90&strip=all&w=664&h=441&crop=1")!)
		usernameLabel.text = UserManager.sharedInstance.user?.userName
	}

	func addObservers() {
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: #selector(showUserPosts),
			name: NotificationKeys.showUserPosts,
			object: nil)
	}

	func removeObservers() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	func settingsButtonTapped() {
		if let navigationViewControllers = (revealViewController().frontViewController as? UINavigationController)?.viewControllers {
			if (!(navigationViewControllers[navigationViewControllers.count - 1] is SettingsController)) {
				(revealViewController().frontViewController as? UINavigationController)?.pushViewController(
					MainAssembly.sharedInstance.getSettingsController(),
					animated: false)
			}
		}
		revealViewController().revealToggleAnimated(true)
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

	func showUserPosts() {
		revealViewController().pushFrontViewController(MainAssembly.sharedInstance.getPostFeedController(.User), animated: true)
	}
}
