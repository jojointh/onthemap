//
//  FacebookClient.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/7/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

class FacebookClient: NSObject {
    
    class func sharedInstance() -> FacebookClient {
        struct Singleton {
            static var sharedInstance = FacebookClient()
        }
        return Singleton.sharedInstance
    }
    
    func facebookLogin(completionHandler: (success: Bool, errorString: String?) -> Void) {
        var fbLoginManager:FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile", "email"]) { result, error in
            if error == nil {
                if result.isCancelled {
                    completionHandler(success: false, errorString: "Login Aborted.")
                } else {
                    var fbloginresult : FBSDKLoginManagerLoginResult = result
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        if let accessToken = FBSDKAccessToken.currentAccessToken() {
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, resultFB, error) -> Void in
                                if error == nil {
                                    let parameters = ["facebook_mobile": ["access_token":accessToken.tokenString]]
                                    
                                    let task = UdacityClient.sharedInstance().taskPostRequest(UdacityClient.Methods.UserSession, postParams: parameters) { result, error in
                                        if let error = error {
                                            if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                                                completionHandler(success: false, errorString: "error.localizedDescription")
                                            } else {
                                                completionHandler(success: false, errorString: "Login unsuccessful.")
                                            }
                                        } else {
                                            if let userID = result.valueForKey("account")?.valueForKey("key") as? String {
                                                let studentInfomation: [String:AnyObject] = [
                                                    "uniqueKey": userID,
                                                    "firstName": resultFB.valueForKey("first_name") ?? "",
                                                    "lastName": resultFB.valueForKey("last_name") ?? ""
                                                ]
                                                
                                                AppData.sharedInstance().userInfomation = StudentInformation(dictionary: studentInfomation)
                                                
                                                completionHandler(success: true, errorString: nil)
                                            } else {
                                                completionHandler(success: false, errorString: "Login unsuccessful. (no user ID)")
                                            }
                                        }
                                    }
                                } else {
                                    completionHandler(success: false, errorString: error.localizedDescription)
                                }
                            })
                        }
                    }
                }
            } else {
                completionHandler(success: false, errorString: error.localizedDescription)
            }
        }
    }
}
