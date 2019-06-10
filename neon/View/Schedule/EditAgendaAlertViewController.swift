//
//  EditAgendaAlertViewController.swift
//  neon
//
//  Created by James Saeed on 07/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class EditAgendaAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

protocol EditAgendaAlertViewDelegate {
    
    func editIconPressed()
    func editTitlePressed()
    func setReminderPressed()
    func sharePressed()
    func cancelPressed()
}
