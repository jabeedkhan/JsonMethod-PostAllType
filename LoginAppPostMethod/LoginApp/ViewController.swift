//
//  ViewController.swift
//  LoginApp
//
//  Created by Jabeed on 7/25/19.
//  Copyright © 2019 Jabeed. All rights reserved.
//

import UIKit

extension String {
    
    
    var isValidEmail: Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    var isValidPhone: Bool {
        let PHONE_REGEX = "^[7-9][0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }

}

class CustomTextFiedld: UITextField {
    
    var bottomBorder = UIView()
    override func awakeFromNib() {
        
        //MARK: Setup Bottom-Border
        self.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        bottomBorder.backgroundColor = UIColor.lightGray
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        //Mark: Setup Anchors
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
        
        
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField:CustomTextFiedld!
    @IBOutlet weak var passwordTextField:CustomTextFiedld!
    
    var bottomView:UIView?
    var bottomLabel:UILabel?
    var isBottomViewPresent:Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        bottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.height + 20, width: self.view.frame.width, height: 45))
        bottomView?.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        
        bottomLabel = UILabel.init(frame: CGRect(x: 8, y: 5, width: self.view.frame.width , height: 30))
        bottomLabel?.textColor = UIColor.white
        bottomLabel?.textAlignment = .center
        bottomView?.addSubview(bottomLabel!)
        self.view.addSubview(bottomView!)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func forgotButtonTapped(_ sender: Any) {
        let alertVC = CustomAlertView.init(nibName: "CustomAlertView", bundle: nil)
        //Present
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overCurrentContext
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender:Any) {
        
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        self.validateLoginCredentials()
        
        
        /*
         
         let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
         self.navigationController?.pushViewController(vc!, animated: true)
         
         */
    }
    
    @IBAction func loginWithFaceBookButtonTapped(_ sender:Any) {
        
        
        
    }
    
    @IBAction func loginWithGoogleButtonTapped(_ sender:Any) {
        
    }
    
    func validateLoginCredentials() {
        
        if self.isBottomViewPresent {
            return
        }
        
        let userNameText = self.userNameTextField?.text
        let passwordText = self.passwordTextField?.text
        
        
        
        if userNameText == nil || passwordText == nil || userNameText?.count == 0 || passwordText!.count <= 3 {
            self.showInvalidErrorMessageWithAnimation(errorMessage: "Invalid Credentials")
            
            
            
        } else {
            
            if userNameText!.isValidEmail {
                
            } else {
                //this is phone nunmber field.
                if  !userNameText!.isValidPhone || userNameText!.count > 10 {
                    self.showInvalidErrorMessageWithAnimation(errorMessage: "Invalid Credentials")
                    return
                }
            }
            //check with the server.
            let loginDictionary = NSMutableDictionary()
            
            let oauthDictioanry = NSMutableDictionary()
            oauthDictioanry.setValue("", forKey: "email")
            oauthDictioanry.setValue("", forKey: "gender")
            oauthDictioanry.setValue("", forKey: "id")
            oauthDictioanry.setValue("1", forKey: "login")
            oauthDictioanry.setValue("", forKey: "name")
            oauthDictioanry.setValue("", forKey: "profileUrl")
            oauthDictioanry.setValue("google", forKey: "type")
            oauthDictioanry.setValue("", forKey: "user_type")
            
            loginDictionary.setValue(oauthDictioanry, forKey: "oauth")
            loginDictionary.setValue(userNameText, forKey: "username")
            loginDictionary.setValue(passwordText, forKey: "password")
            loginDictionary.setValue("M", forKey: "user_type")
            
            
            RestUrlConnection.validateLoginCredentialsWithServer(loginDictionaryParams: loginDictionary) { (error:NSError?,data:NSMutableDictionary?)  -> Void in
                DispatchQueue.main.async {
                    print(data!)
                    if data!.allKeys.count > 0 {
                        let errorMessage = data?["message"] as! NSString
                        if  errorMessage.length > 0 {
                            self.showInvalidErrorMessageWithAnimation(errorMessage: errorMessage as String)
                        } else {
                            self.showInvalidErrorMessageWithAnimation(errorMessage: "validation successful")
                        }
                    }
                }
            }
        }
    }
    
    func showInvalidErrorMessageWithAnimation(errorMessage:String) {
        bottomLabel?.text = errorMessage  //"Invalid Credentials"
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.isBottomViewPresent = true
            self.bottomView?.frame.origin.y = self.bottomView!.frame.origin.y - self.bottomView!.frame.height - 10
        }, completion: { finished in
            
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
                self.bottomView?.frame.origin.y = self.view.frame.height + 20
            }, completion: { finished in
                self.isBottomViewPresent = false
                
            })
            
        })
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            userNameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField ==  passwordTextField {
            passwordTextField.resignFirstResponder()
            
        }
        
        return true
    }
    
}
