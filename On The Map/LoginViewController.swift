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
        let session = NSURLSession.sharedSession()
        let baseURL = "https://www.udacity.com/"
        let requestMethod = "api/session"
        
        let postParams = ["udacity":
            [ "username": emailTextField.text,
              "password": passwordTextField.text
            ]
        ]
        
        let requestPostData = NSJSONSerialization.dataWithJSONObject(postParams, options: nil, error: nil)
        
        let urlString = baseURL + requestMethod
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = requestPostData

        let task = session.dataTaskWithRequest(request) {
            data, response, errorRequest in
            if let error = errorRequest {
                println("something wrong")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                var parsingError: NSError? = nil
                let parsedJSON = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                println(parsedJSON)
            }
        }
        
        task.resume()
    }
    
    @IBAction func doSignUp(sender: UIButton) {
        
    }
}

