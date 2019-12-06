//
//  CustomAlertView.swift
//  LoginApp
//
//  Created by Jabeed on 02/08/19.
//  Copyright © 2019 Jabeed. All rights reserved.
//

import UIKit


class MobileTextFiedld: UITextField {
    
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

class CustomAlertView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var mobileLabel:UILabel!
    @IBOutlet weak var mobileTextField:MobileTextFiedld!
    @IBOutlet weak var errorMessageLabel:UILabel!
    
    var enteredMobileString:String?

    override func viewDidLoad() {
      super.viewDidLoad()
//      self.addDoneButtonOnKeyboard()
      
      NotificationCenter.default.addObserver(self, selector: #selector(CustomAlertView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(CustomAlertView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let mobileText =  self.enteredMobileString {
            self.mobileTextField?.text = mobileText as String
        }
        
        mobileTextField.becomeFirstResponder()
        
        mobileTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewContainer.layer.masksToBounds = true
        mobileLabel.textColor = UIColor.orange
      
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {        
        if textField.text!.count >= 10 {
            self.presentOTPViewController()
        }
    }
  
  
    func addDoneButtonOnKeyboard() {
      let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))

      doneToolbar.barStyle = UIBarStyle.blackTranslucent
      
      let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
      let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CustomAlertView.doneButtonAction))
      
      let items = NSMutableArray()
      items.add(flexSpace)
      items.add(done)
      
      doneToolbar.items = items as? [UIBarButtonItem]
      doneToolbar.sizeToFit()
      
      self.mobileTextField.inputAccessoryView = doneToolbar
      
    }
  
  func presentOTPViewController(){
    if self.mobileTextField.isFirstResponder {
      self.mobileTextField.resignFirstResponder()
      let phone = self.mobileTextField!.text
      if phone == nil || !self.isValidMobileNumber(value: phone!) {
        self.errorMessageLabel.text = "Invalide Mobile Number"
        self.errorMessageLabel.textColor = UIColor.orange
        self.errorMessageLabel.isHidden = false
      } else {
        // this logic is valide mobile number
        self.errorMessageLabel.isHidden = true
        
        let paramsDictionary = NSMutableDictionary()
        paramsDictionary.setValue(phone, forKey: "mobile")
        paramsDictionary.setValue("M", forKey: "user_type")
        
        RestUrlConnection.verifyMobileNumberWithServer(params: paramsDictionary) { (error:NSError?,data:NSMutableDictionary?)  -> Void in
            DispatchQueue.main.async {
                if let serverResponse = data {
                    let errorNumber = serverResponse["error"] as! Int
                    if  errorNumber == 0 {
                        //show the error message here.
                        self.errorMessageLabel.isHidden = false
                        self.errorMessageLabel.text = "Mobile Not Found"
                    } else {
                        //show OPT view
                        
                        self.errorMessageLabel.isHidden = true
                        self.errorMessageLabel.text = "Mobile already present"
                        
                        self.dismiss(animated: false, completion: nil)

                        let vc = VerifyMobileNumberViewController.init(nibName: "VerifyMobileNumberViewController", bundle: nil)
                        vc.enteredMobileString = phone! as NSString
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext

                        let rootVC = self.view?.window?.rootViewController
                        rootVC?.present(vc, animated: true, completion: nil)

                    }
                }
            }
        }
        
      }
    }
  }
  
  @objc func doneButtonAction(){
      if self.mobileTextField.isFirstResponder {
        self.mobileTextField.resignFirstResponder()
        let phone = self.mobileTextField!.text
        if phone == nil || !self.isValidMobileNumber(value: phone!) {
          self.errorMessageLabel.text = "Invalide Mobile Number"
          self.errorMessageLabel.textColor = UIColor.orange
          self.errorMessageLabel.isHidden = false
        } else {
          // this logic is valide mobile number
          self.errorMessageLabel.isHidden = true
          self.dismiss(animated: false, completion: nil)
          
          let vc = VerifyMobileNumberViewController.init(nibName: "VerifyMobileNumberViewController", bundle: nil)
          vc.enteredMobileString = phone! as NSString
          vc.modalTransitionStyle = .crossDissolve
          vc.modalPresentationStyle = .overCurrentContext
          
          let rootVC = self.view?.window?.rootViewController
          rootVC?.present(vc, animated: true, completion: nil)
          
        }
      }
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

  
    func isValidMobileNumber(value: String) -> Bool {
        let PHONE_REGEX = "^[7-9][0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mobileTextField.isFirstResponder {
            mobileTextField.resignFirstResponder()
            let phone = self.mobileTextField!.text
            if phone == nil || !self.isValidMobileNumber(value: phone!) {
                self.errorMessageLabel.text = "Invalide Mobile Number"
                self.errorMessageLabel.textColor = UIColor.orange
                self.errorMessageLabel.isHidden = false
            } else {
                // this logic is valide mobile number
                self.errorMessageLabel.isHidden = true
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
  
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if string.isEmpty { return true }
    let currentText = textField.text ?? ""
    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
    if updatedText.count <= 10 {
      return true
    } else {
      return false
    }
    
  }
  
}
