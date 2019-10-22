//
//  FeedbackSettingCell.swift
//  neon
//
//  Created by James Saeed on 16/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class FeedbackSettingCell: UITableViewCell, UITextViewDelegate {

	@IBOutlet weak var twitterButton: UIButtonX!
	
	func build() {
		twitterButton.setTitle(AppStrings.Settings.twitter, for: .normal)
	}
	
	@IBAction func followTwitterPressed(_ sender: Any) {
		let url = URL(string: "twitter://user?screen_name=j_t_saeed")!
		
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.open(URL(string: "https://twitter.com/j_t_saeed")!, options: [:], completionHandler: nil)
		}
	}
}
