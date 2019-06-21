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

    @IBOutlet weak var bottomInset: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIViewX!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var cancelButton: UIButtonX!
    @IBOutlet weak var doneButton: UIButtonX!
    
    var priority = ToDoPriority.none
    var index: Int?
    var editingTitle: String?
    
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
            prioritySlider.minimumTrackTintColor = UIColor(named: "noPriority")!
            priorityLabel.text = "No priority"
            priority = .none
        } else if prioritySlider.value >= 0.25 && prioritySlider.value < 0.5 {
            prioritySlider.minimumTrackTintColor = UIColor(named: "lowPriority")!
            priorityLabel.text = "Low priority"
            priority = .low
        } else if prioritySlider.value >= 0.5 && prioritySlider.value < 0.75 {
            prioritySlider.minimumTrackTintColor = UIColor(named: "medPriority")!
            priorityLabel.text = "Medium priority"
            priority = .medium
        } else {
            prioritySlider.minimumTrackTintColor = UIColor(named: "highPriority")!
            priorityLabel.text = "High priority"
            priority = .high
        }
    }
    
    func setPrioritySlider() {
        if priority == .low {
            prioritySlider.value = 0.25
            priorityLabel.text = "Low priority"
            prioritySlider.minimumTrackTintColor = UIColor(named: "lowPriority")!
        } else if priority == .medium {
            prioritySlider.value = 0.5
            priorityLabel.text = "Medium priority"
            prioritySlider.minimumTrackTintColor = UIColor(named: "medPriority")!
        } else if priority == .high {
            prioritySlider.value = 0.75
            priorityLabel.text = "High priority"
            prioritySlider.minimumTrackTintColor = UIColor(named: "highPriority")!
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        handleDone()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        titleTextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleDone() {
        if !(titleTextField.text?.isEmpty)! {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            titleTextField.resignFirstResponder()
            delegate?.doneButtonTapped(index: index, textFieldValue: titleTextField.text!, priority: priority)
            self.dismiss(animated: true, completion: nil)
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}

extension AddToDoAlertViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleDone()
        return true
    }
}

// MARK: - UI

extension AddToDoAlertViewController {
    
    func setupView() {
        setupInset()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
        titleTextField.delegate = self
        if let title = editingTitle { titleTextField.text = title }
        setPrioritySlider()
        
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
        
        if model.contains("iPhone 6") || model.contains("iPhone 7") || model.contains("iPhone 8") {
            bottomInset.constant = 256
        } else if model == "iPhone SE" || model == "iPhone 5S" {
            bottomInset.constant = 192
        } else if model.contains("iPad") {
            bottomInset.constant = 448
        }
    }
}

// MARK: - Delegate

protocol AddToDoDelegate {
    
    func doneButtonTapped(index: Int?, textFieldValue: String, priority: ToDoPriority)
    func cancelButtonTapped()
}
