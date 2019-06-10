//
//  AddToDoAlertViewController.swift
//  neon
//
//  Created by James Saeed on 07/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class AddToDoAlertViewController: UIViewController {
    
    var delegate: AddToDoDelegate?

    @IBOutlet weak var alertView: UIViewX!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var cancelButton: UIButtonX!
    @IBOutlet weak var doneButton: UIButtonX!
    
    var priority = ToDoPriority.none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        animateView()
    }
    
    @IBAction func prioritySliderPressed(_ sender: Any) {
        if prioritySlider.value >= 0 && prioritySlider.value < 0.25 {
            prioritySlider.minimumTrackTintColor = .gray
            priorityLabel.text = "No priority"
            priority = .none
        } else if prioritySlider.value >= 0.25 && prioritySlider.value < 0.5 {
            prioritySlider.minimumTrackTintColor = .yellow
            priorityLabel.text = "Low priority"
            priority = .low
        } else if prioritySlider.value >= 0.5 && prioritySlider.value < 0.75 {
            prioritySlider.minimumTrackTintColor = .orange
            priorityLabel.text = "Medium priority"
            priority = .medium
        } else {
            prioritySlider.minimumTrackTintColor = .red
            priorityLabel.text = "High priority"
            priority = .high
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if !(titleTextField.text?.isEmpty)! {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            titleTextField.resignFirstResponder()
            delegate?.doneButtonTapped(textFieldValue: titleTextField.text!, priority: priority)
            self.dismiss(animated: true, completion: nil)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        titleTextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UI

extension AddToDoAlertViewController {
    
    func setupView() {
//        setupInset()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
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
    
    /*
    func setupInset() {
        let model = UIDevice.current.name
        if model == "iPhone SE" || model == "iPhone 5S" {
            bottomInset.constant = 288
        } else if model.contains("iPad") {
            bottomInset.constant = 448
        }
    }
 */
}

// MARK: - Delegate

protocol AddToDoDelegate {
    
    func doneButtonTapped(textFieldValue: String, priority: ToDoPriority)
    func cancelButtonTapped()
}
