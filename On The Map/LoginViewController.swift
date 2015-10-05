//
//  ViewController.swift
//  On The Map
//
//  Created by Surasak on 9/28/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    @IBAction func loginFacebook(sender: UIButton) {
        activityIndicator.startAnimating()
        var fbLoginManager:FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile", "email"]) { result, error in
            if error == nil {
                if result.isCancelled {
                    self.displayAlert("Login Aborted.")
                } else {
                    var fbloginresult : FBSDKLoginManagerLoginResult = result
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            } else {
                self.displayAlert(error.localizedDescription)
            }
        }
    }
    
    func getFBUserData() {
        if let accessToken = FBSDKAccessToken.currentAccessToken() {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, resultFB, error) -> Void in
                if error == nil {
                    let parameters = ["facebook_mobile": ["access_token":accessToken.tokenString]]
                    
                    let task = UdacityClient.sharedInstance().taskPostRequest(UdacityClient.Methods.UserSession, postParams: parameters) { result, error in
                        if let error = error {
                            if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                                self.displayAlert(error.localizedDescription)
                            } else {
                                self.displayAlert("Login unsuccessful.")
                            }
                        } else {
                            if let userID = result.valueForKey("account")?.valueForKey("key") as? String {
                                let studentInfomation: [String:AnyObject] = [
                                    "uniqueKey": userID,
                                    "firstName": resultFB.valueForKey("first_name") ?? "",
                                    "lastName": resultFB.valueForKey("last_name") ?? ""
                                ]
                                
                                UdacityClient.sharedInstance().userInfomation = StudentInformation(studentInfomation: studentInfomation)
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.activityIndicator.stopAnimating()
                                    self.performSegueWithIdentifier("studentLocation", sender: self)
                                }
                            } else {
                                self.displayAlert("Login unsuccessful. (no user ID)")
                            }
                        }
                    }
                } else {
                    self.displayAlert(error.localizedDescription)
                }
            })
        }
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func doLogin(sender: UIButton) {
        //input should not empty
        if emailTextField.text.isEmpty || passwordTextField.text.isEmpty {
            displayAlert("Empty Email or Password.")
        } else {
            activityIndicator.startAnimating()
            let postParams = ["udacity":
                [ "username": emailTextField.text,
                  "password": passwordTextField.text
                ]
            ]
            let task = UdacityClient.sharedInstance().taskPostRequest(UdacityClient.Methods.UserSession, postParams: postParams) { result, error in
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                }
                if let error = error {
                    if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                        self.displayAlert(error.localizedDescription)
                    } else {
                        self.displayAlert("Could not login")
                    }
                } else {
                    if let error = result.valueForKey("error") as? String {
                        if result.valueForKey("status") as? Int == 403 {
                            self.displayAlert("Invalid Email or Password.")
                        } else {
                            self.displayAlert("Login Error")
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
                                        self.displayAlert(error.localizedDescription)
                                    } else {
                                        self.displayAlert("Could no get user data.")
                                    }
                                } else {
                                    if let user = result.valueForKey("user") as? [String:AnyObject] {
                                        let studentInfomation: [String:AnyObject] = [
                                            "uniqueKey": userID,
                                            "firstName": user["first_name"] ?? "",
                                            "lastName": user["last_name"] ?? ""
                                        ]
                                        
                                        UdacityClient.sharedInstance().userInfomation = StudentInformation(studentInfomation: studentInfomation)
                                        
                                        dispatch_async(dispatch_get_main_queue()) {
                                            self.emailTextField.text = ""
                                            self.passwordTextField.text = ""
                                            self.performSegueWithIdentifier("studentLocation", sender: self)
                                        }
                                    }
                                }
                            }
                        } else {
                            self.displayAlert("Account data not found.")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func doSignUp(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

