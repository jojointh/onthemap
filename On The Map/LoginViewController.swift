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
        let postParams = ["udacity":
            [ "username": emailTextField.text,
              "password": passwordTextField.text
            ]
        ]
        let task = UdacityClient.sharedInstance().taskPostRequest(UdacityClient.Methods.UserSession, postParams: postParams) { result, error in
            if let error = error {
                
            } else {
                //TODO: complete login
            }
        }
    }
    
    @IBAction func doSignUp(sender: UIButton) {
        
    }
}

