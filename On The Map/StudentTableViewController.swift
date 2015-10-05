//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/4/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().taskDeleteRequest(UdacityClient.Methods.UserSession) {
            result, error in
            if let error = error {
                if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                    self.displayAlert(error.localizedDescription)
                } else {
                    self.displayAlert("Logout not successful.")
                }
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentInformationList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableCell", forIndexPath: indexPath) as! UITableViewCell
        
        let student = ParseClient.sharedInstance().studentInformationList[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = ParseClient.sharedInstance().studentInformationList[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL)!)
    }
}
