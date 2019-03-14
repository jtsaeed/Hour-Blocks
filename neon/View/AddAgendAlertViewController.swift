//
//  AddAgendAlertViewController.swift
//  neon
//
//  Created by James Saeed on 20/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class AddAgendAlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIViewX!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: AddAgendaAlertViewDelegate?
    var indexPath: IndexPath!
    var time: String!
    
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
        if !(titleTextField.text?.isEmpty)! {
            titleTextField.resignFirstResponder()
            delegate?.doneButtonTapped(textFieldValue: titleTextField.text!, indexPath: indexPath!)
            self.dismiss(animated: true, completion: nil)
        } else {
            // TODO: Generate haptic feedback
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        titleTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddAgendAlertViewController {
    
    func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        titleLabel.text = "What's in store at \(time!)?"
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 100
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 100
        })
    }
}

protocol AddAgendaAlertViewDelegate {
    
    func doneButtonTapped(textFieldValue: String, indexPath: IndexPath)
}
