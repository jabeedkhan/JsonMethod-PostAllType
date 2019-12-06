//
//  VerifyMobileNumberViewController.swift
//  LoginApp
//
//  Created by jabeed on 06/08/19.
//  Copyright © 2019 jabeed. All rights reserved.
//

import UIKit

class VerifyTextFiedld: UITextField {
  
  var bottomBorder = UIView()
  override func awakeFromNib() {
    
    //MARK: Setup Bottom-Border
    self.translatesAutoresizingMaskIntoConstraints = false
    bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    bottomBorder.backgroundColor = UIColor.black
    bottomBorder.translatesAutoresizingMaskIntoConstraints = false
    addSubview(bottomBorder)
    //Mark: Setup Anchors
    bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
    
  }
}

class OTPTextFiedld: UITextField {
  
  var bottomBorder = UIView()
  override func awakeFromNib() {
    
    //MARK: Setup Bottom-Border
    self.translatesAutoresizingMaskIntoConstraints = false
    bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    bottomBorder.backgroundColor = UIColor.orange
    bottomBorder.translatesAutoresizingMaskIntoConstraints = false
    addSubview(bottomBorder)
    //Mark: Setup Anchors
    bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
    
  }
}

class VerifyMobileNumberViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var mobileTextField:VerifyTextFiedld!
  @IBOutlet weak var otpTextField:OTPTextFiedld!
  @IBOutlet weak var resendButton:UIButton!
  @IBOutlet weak var otpErrorLabel:UILabel!
  
  var enteredMobileString:NSString?

    override func viewDidLoad() {
      super.viewDidLoad()
      NotificationCenter.default.addObserver(self, selector: #selector(CustomAlertView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(CustomAlertView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//      self.addDoneButtonOnKeyboard()
      
      if let mobileText =  self.enteredMobileString {
        self.mobileTextField?.text = mobileText as String
      }
      
      resendButton.layer.cornerRadius = 5
      resendButton.layer.borderWidth = 1
      resendButton.layer.borderColor = UIColor.blue.cgColor
      
      otpTextField.delegate = self
      mobileTextField.delegate = self
        
      otpTextField.becomeFirstResponder()
      otpErrorLabel.textColor = UIColor.red
        
      mobileTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
      otpTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func resendButtonTapped(_ sender: Any) {
    
  }
  
  func addDoneButtonOnKeyboard() {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    
    doneToolbar.barStyle = UIBarStyle.blackTranslucent
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.done, target: self, action: #selector(CustomAlertView.doneButtonAction))
    
    let items = NSMutableArray()
    items.add(flexSpace)
    items.add(done)
    
    doneToolbar.items = items as? [UIBarButtonItem]
    doneToolbar.sizeToFit()
    
    self.mobileTextField.inputAccessoryView = doneToolbar
    self.otpTextField.inputAccessoryView = doneToolbar
    
  }
  
  @objc func doneButtonAction(){
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= keyboardSize.height/2
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if mobileTextField.isFirstResponder {
      mobileTextField.resignFirstResponder()
    }
    
    if otpTextField.isFirstResponder {
      otpTextField.resignFirstResponder()
    }
    
    self.dismiss(animated: true, completion: nil)
    
  }
    
    @objc func textFieldDidChange(_ textField: UITextField) { //otp check
        
        if textField == otpTextField {
            if otpTextField.text!.count > 4 {
                otpErrorLabel.isHidden = false
                otpErrorLabel?.text = "Invalid"
            } else if otpTextField.text!.count == 4 {
                otpErrorLabel.isHidden = true
                self.validateOTPWithServer()
            } else {
                otpErrorLabel.isHidden = false
                otpErrorLabel?.text = "Invalid"
            }
        } else if textField == mobileTextField{
            
            if mobileTextField.text!.count >= 10 {
            } else {
                self.dismiss(animated: false, completion: nil)
                let vc = CustomAlertView.init(nibName: "CustomAlertView", bundle: nil)
                vc.enteredMobileString = mobileTextField.text!
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                
                let rootVC = self.view?.window?.rootViewController
                rootVC?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return true
  }
  
  func validateOTPWithServer() {
    
    let mobileNumber = self.mobileTextField.text!
    let otpString = otpTextField.text!
    let paramsDictionary = NSMutableDictionary()
    paramsDictionary.setValue(mobileNumber, forKey: "mobile")
    paramsDictionary.setValue("M", forKey: "user_type")
    paramsDictionary.setValue(otpString, forKey: "signup")
    
    RestUrlConnection.verifyOTPWithServer(params: paramsDictionary) { (error:NSError?,data:NSMutableDictionary?)  -> Void in
      DispatchQueue.main.async {
        if let response = data {
          print(response)

        }
      }
    }
  }

}


