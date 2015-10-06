//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/4/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class StudentTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //custom navigation button
        let reloadButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "reload:")
        let pinButton = UIBarButtonItem(image: UIImage(named: "pinButton"), style: UIBarButtonItemStyle.Plain, target: self, action: "addPin:")
        navigationItem.rightBarButtonItems = [reloadButton, pinButton]
    }
    
    func reload(sender: AnyObject) {
        AppData.sharedInstance().studentInformationList.removeAll()
        ParseClient.sharedInstance().getStudentLocation() {
            studentLocationList, errorString in
            if let studentLocationList = studentLocationList {
                for student in studentLocationList {
                    let studentInformation = StudentInformation(dictionary: student)
                    AppData.sharedInstance().studentInformationList.append(studentInformation)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                if let errorString = errorString {
                    self.displayAlert(errorString)
                } else {
                    self.displayAlert("Get student location unsuccessful.")
                }
            }
        }
    }
    
    func addPin(sender: AnyObject) {
        performSegueWithIdentifier("showLocationSelect", sender: self)
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
                FBSDKLoginManager().logOut()
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
        return AppData.sharedInstance().studentInformationList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableCell", forIndexPath: indexPath) as! StudentCell
        
        let student = AppData.sharedInstance().studentInformationList[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.latitude = student.latitude
        cell.longitude = student.longitude
        cell.tableView = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = AppData.sharedInstance().studentInformationList[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL)!)
    }
}
