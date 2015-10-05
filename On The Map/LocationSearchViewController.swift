//
//  LocationSearchViewController.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/5/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var locationTextField: UITextView!
    let placeholder = "Enter Your Location Here"
    let foundLocation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        locationTextField.text = placeholder
        locationTextField.textColor = UIColor.lightGrayColor()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    @IBAction func findLocation(sender: UIButton) {
        if locationTextField.textColor == UIColor.lightGrayColor() {
            displayAlert("Must Enter a Location.")
        } else {
            CLGeocoder().geocodeAddressString(locationTextField.text) {
                placemarks, error in
                if let error = error {
                    self.displayAlert(error.localizedDescription)
                } else {
                    if let placemark = placemarks.first as? CLPlacemark {
                        self.foundLocation.coordinate = placemark.location.coordinate
                        
                        self.performSegueWithIdentifier("LocationAddLink", sender: self)
                    }
                }
            }
        }
    }
    
    @IBAction func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! LocationAddLinkViewController
        destinationVC.foundLocation = foundLocation
        destinationVC.searchString = locationTextField.text
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
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