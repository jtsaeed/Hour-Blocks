//
//  AddAgendAlertViewController.swift
//  neon
//
//  Created by James Saeed on 20/02/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class AddAgendAlertViewController: UIViewController {

    @IBOutlet weak var topInset: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIViewX!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        if !(titleTextField.text?.isEmpty)! {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            titleTextField.resignFirstResponder()
            delegate?.doneButtonTapped(textFieldValue: titleTextField.text!, indexPath: indexPath!)
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

extension AddAgendAlertViewController {
    
    func setupView() {
        setupInset()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        titleLabel.text = "What's in store at \(time!)?"
        titleTextField.text = preFilledTitle
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
            topInset.constant = 64
        } else if model == "iPhone Xs Max" || model == "iPhone Xr" {
            topInset.constant = 192
        } else if model.contains("iPad") {
            topInset.constant = 384
        }
    }
}

protocol AddAgendaAlertViewDelegate {
    
    func doneButtonTapped(textFieldValue: String, indexPath: IndexPath)
    func cancelButtonTapped()
}
