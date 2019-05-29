//
//  OtherSettingCell.swift
//  neon
//
//  Created by James Saeed on 28/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

protocol OtherSettingDelegate {
	
	func toggleOtherSetting(to status: Bool)
}

class OtherSettingCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var toggleSwitch: UISwitch!
	
	var delegate: OtherSettingDelegate!
	
	func build() {
		titleLabel.text = AppStrings.Settings.nightTimeHours
		toggleSwitch.isOn = true
	}

	@IBAction func switchPressed(_ sender: Any) {
		delegate.toggleOtherSetting(to: toggleSwitch.isOn)
	}
}
