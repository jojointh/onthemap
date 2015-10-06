//
//  ViewController.swift
//  On The Map
//
//  Created by Surasak on 9/28/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit

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
        FacebookClient.sharedInstance().facebookLogin {
            success, errorString in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("studentLocation", sender: self)   
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                }
                if let errorString = errorString {
                    self.displayAlert(errorString)
                } else {
                    self.displayAlert("FB Login Error")
                }
            }
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
            UdacityClient.sharedInstance().udacityLogin(postParams) {
                success, errorString in
                if success {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.activityIndicator.stopAnimating()
                        //clear login textfield in case of user logout
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.performSegueWithIdentifier("studentLocation", sender: self)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.activityIndicator.stopAnimating()
                    }
                    if let errorString = errorString {
                        self.displayAlert(errorString)
                    } else {
                        self.displayAlert("Udacity Login Error")
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
            self.view.shakeSubview()
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

