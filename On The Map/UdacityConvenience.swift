//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/7/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit

// MARK: - Convenient Resource Methods

extension UdacityClient {
    func udacityLogin(postParams: [String: AnyObject], completionHandler: (success: Bool, errorString: String?) -> Void) {
        let task = UdacityClient.sharedInstance().taskPostRequest(UdacityClient.Methods.UserSession, postParams: postParams) { result, error in
            if let error = error {
                if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                    completionHandler(success: false, errorString: error.localizedDescription)
                } else {
                    completionHandler(success: false, errorString: "Could not login")
                }
            } else {
                if let error = result.valueForKey("error") as? String {
                    if result.valueForKey("status") as? Int == 403 {
                        completionHandler(success: false, errorString: "Invalid Email or Password.")
                    } else {
                        completionHandler(success: false, errorString: "Login Error")
                    }
                } else {
                    //get user data
                    if let userID = result.valueForKey("account")?.valueForKey("key") as? String {
                        var mutableMethod: String = UdacityClient.Methods.UserData
                        mutableMethod = UdacityClient.subtituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.userID, value: userID)!
                        UdacityClient.sharedInstance().taskGetRequest(mutableMethod, parameters: [String : AnyObject]()) {
                            result, error in
                            
                            if let error = error {
                                if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                                    completionHandler(success: false, errorString: error.localizedDescription)
                                } else {
                                    completionHandler(success: false, errorString: "Could no get user data.")
                                }
                            } else {
                                if let user = result.valueForKey("user") as? [String:AnyObject] {
                                    let studentInfomation: [String:AnyObject] = [
                                        "uniqueKey": userID,
                                        "firstName": user["first_name"] ?? "",
                                        "lastName": user["last_name"] ?? ""
                                    ]
                                    
                                    AppData.sharedInstance().userInfomation = StudentInformation(dictionary: studentInfomation)
                                    
                                    completionHandler(success: true, errorString: nil)
                                }
                            }
                        }
                    } else {
                        completionHandler(success: false, errorString: "Account data not found.")
                    }
                }
            }
        }
    }
}
