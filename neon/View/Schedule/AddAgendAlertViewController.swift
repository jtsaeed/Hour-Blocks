//
//  AddAgendAlertViewController.swift
//  neon
//
//  Created by James Saeed on 20/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class AddAgendAlertViewController: UIViewController {

	@IBOutlet weak var bottomInset: NSLayoutConstraint!
	@IBOutlet weak var alertView: UIViewX!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var cancelButton: UIButtonX!
	@IBOutlet weak var doneButton: UIButtonX!
	
    var delegate: AddAgendaAlertViewDelegate?
    var indexPath: IndexPath!
    var time: String!
    var preFilledTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        animateView()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
		handleDone()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        titleTextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddAgendAlertViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		handleDone()
		return true
	}
}

// MARK: - UI

extension AddAgendAlertViewController {
    
    func setupView() {
        setupInset()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        titleLabel.text = String(format: AppStrings.Schedule.addAgendaTitle, time)
        titleTextField.text = preFilledTitle
		titleTextField.delegate = self
		titleTextField.returnKeyType = .done
		
		cancelButton.setTitle(AppStrings.cancel.uppercased(), for: .normal)
		doneButton.setTitle(AppStrings.Schedule.done.uppercased(), for: .normal)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 100
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 100
        })
    }
    
    func setupInset() {
        let model = UIDevice.current.name
        if model == "iPhone SE" || model == "iPhone 5S" {
            bottomInset.constant = 288
        } else if model.contains("iPad") {
            bottomInset.constant = 448
        }
    }
}

extension AddAgendAlertViewController {
	
	func handleDone() {
		if !(titleTextField.text?.isEmpty)! {
			UINotificationFeedbackGenerator().notificationOccurred(.success)
			titleTextField.resignFirstResponder()
			delegate?.doneButtonTapped(textFieldValue: titleTextField.text!, indexPath: indexPath!)
			self.dismiss(animated: true, completion: nil)
		} else {
			UINotificationFeedbackGenerator().notificationOccurred(.error)
		}
	}
	
	func handleCancel() {
		
	}
}

protocol AddAgendaAlertViewDelegate {
    
    func doneButtonTapped(textFieldValue: String, indexPath: IndexPath)
    func cancelButtonTapped()
}
