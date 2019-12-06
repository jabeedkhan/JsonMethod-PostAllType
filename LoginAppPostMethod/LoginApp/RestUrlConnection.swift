//
//  RestUrlConnection.swift
//  LoginApp
//
//  Created by jabeed on 07/08/19.
//  Copyright © 2019 Jabeed. All rights reserved.
//

import UIKit

class RestUrlConnection: NSURLConnection {
    
    /*
     Below method is used to check login credentials in the server.
     */
    class  func validateLoginCredentialsWithServer(loginDictionaryParams:NSMutableDictionary,callbackHandler:((NSError?, NSMutableDictionary?) -> Void)!) {
        let urlString = String(format:"https://papa.fit/routes/registrationRoute.php?action=checkCredentials")
        
        let query  = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url:URL(string:query!)!)
        request.timeoutInterval = 180
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: loginDictionaryParams, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if data != nil{
                    do {
                        let json = try JSONSerialization.jsonObject(with:data!, options: [])
                        let jsonDictionary = NSMutableDictionary(dictionary: json as! NSDictionary)
                        callbackHandler(nil,jsonDictionary)
                    } catch let error as NSError {
                        callbackHandler(error, nil)
                    }
                }else{
                    callbackHandler(error! as NSError, nil)
                }
            })
            task.resume()
            
        } catch {
            
        }
        
    }
    
    
    /*
     Below method is used to check weather the mobile number is exits or not in the server.
    */
    class  func verifyMobileNumberWithServer(params:NSMutableDictionary,callbackHandler:((NSError?, NSMutableDictionary?) -> Void)!) {
        let urlString = String(format:"https://papa.fit/routes/registrationRoute.php?action=validateMobile")
        
        let query  = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url:URL(string:query!)!)
        request.timeoutInterval = 180
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let respone = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with:respone, options: [])
                        let jsonDictionary = NSMutableDictionary(dictionary: json as! NSDictionary)
                        callbackHandler(nil,jsonDictionary)
                    } catch let error as NSError {
                        callbackHandler(error, nil)
                    }
                }else{
                    callbackHandler(error! as NSError, nil)
                }
            })
            task.resume()
            
        } catch {
            
        }
        
    }
  
  
  /*
   Below method is used to check weather OTP in the server.
   */
  class  func verifyOTPWithServer(params:NSMutableDictionary,callbackHandler:((NSError?, NSMutableDictionary?) -> Void)!) {
    let urlString = String(format:"https://papa.fit/routes/registrationRoute.php?action=sendOtp")
    
    let query  = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    var request = URLRequest(url:URL(string:query!)!)
    request.timeoutInterval = 180
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
      request.httpBody = jsonData
      let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
        if data != nil{
          do {
            let json = try JSONSerialization.jsonObject(with:data!, options: [])
            let jsonDictionary = NSMutableDictionary(dictionary: json as! NSDictionary)
            callbackHandler(nil,jsonDictionary)
          } catch let error as NSError {
            callbackHandler(error, nil)
          }
        }else{
          callbackHandler(error! as NSError, nil)
        }
      })
      task.resume()
      
    } catch {
      
    }
    
  }
    
    
    
    
    
    
    
}
