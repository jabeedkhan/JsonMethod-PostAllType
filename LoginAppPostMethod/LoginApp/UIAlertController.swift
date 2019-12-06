//
//  UIAlertController.swift
//  LoginApp
//
//  Created by jabeed on 02/08/19.
//  Copyright © 2019 Jabeed. All rights reserved.
//

import UIKit

class UIAlertController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let alert = UIAlertController(title: "Enter Mobile No.", message: "This is an alert.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
    NSLog("The \"OK\" alert occured.")
    }))
    
    self.present(alert, animated: true, completion: nil)
    

}
