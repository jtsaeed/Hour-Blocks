//
//  NoConnectionViewController.swift
//  neon
//
//  Created by James Saeed on 28/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class NoConnectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkAgainPressed(_ sender: Any) {
        checkConnection()
    }
    
    func checkConnection() {
        DataGateway.shared.checkConnection { (success) in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
        }
    }
}
