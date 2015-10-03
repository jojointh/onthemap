//
//  ViewController.swift
//  On The Map
//
//  Created by Surasak on 9/28/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doLogin(sender: UIButton) {
        //input should not empty
        if emailTextField.text.isEmpty || passwordTextField.text.isEmpty {
            let alert = UIAlertController(title: "", message: "Empty Email or Password.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            let postParams = ["udacity":
                [ "username": emailTextField.text,
                  "password": passwordTextField.text
                ]
            ]
            let task = UdacityClient.sharedInstance().taskPostRequest(UdacityClient.Methods.UserSession, postParams: postParams) { result, error in
                if let error = error {
                    println(error)
                } else {
                    println("completed login")
                    println(result)
                    if let error = result.valueForKey("error") as? String {
                        
                        if result.valueForKey("status") as? Int == 403 {
                            let alert = UIAlertController(title: "", message: "Invalid Email or Password.", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                            dispatch_async(dispatch_get_main_queue()) {
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                    } else {
                        //TODO: complete login
                    }
                }
            }
        }
    }
    
    @IBAction func doSignUp(sender: UIButton) {
        
    }
}

