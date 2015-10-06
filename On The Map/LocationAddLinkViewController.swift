//
//  LocationAddLinkViewController.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/5/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit
import MapKit

class LocationAddLinkViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addLinkTextView: UITextView!
    @IBOutlet weak var previewLinkButton: UIButton!

    let placeholder = "Enter a Link to Share Here"
    var foundLocation = MKPointAnnotation()
    var searchString = ""
    
    override func viewWillAppear(animated: Bool) {
        addLinkTextView.text = placeholder
        addLinkTextView.textColor = UIColor.lightGrayColor()
        let pinAnnotationView = MKPinAnnotationView(annotation: foundLocation, reuseIdentifier: nil)
        let region = MKCoordinateRegionMakeWithDistance(foundLocation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(pinAnnotationView.annotation)
    }
    
    @IBAction func confirmLocation(sender: UIButton) {
        if addLinkTextView.textColor == UIColor.lightGrayColor() {
            displayAlert("Must Enter a Link.")
        } else {
            if let url = NSURL(string: addLinkTextView.text) {
                if UIApplication.sharedApplication().canOpenURL(url) {
                    var parameters = UdacityClient.sharedInstance().userInfomation.getDictionary()
                    parameters["mediaURL"] = addLinkTextView.text
                    parameters["mapString"] = searchString
                    parameters["latitude"] = foundLocation.coordinate.latitude
                    parameters["longitude"] = foundLocation.coordinate.longitude
                    
                    ParseClient.sharedInstance().taskPostRequest(ParseClient.Methods.StudentLocation, postParams: parameters) {
                        result, error in
                        if let error = error {
                            if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                                self.displayAlert(error.localizedDescription)
                            } else {
                                self.displayAlert("Could no save location.")
                            }
                        } else {
                            if let error = result.valueForKey("error") as? String {
                                self.displayAlert(error)
                            } else {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                                }
                            }
                        }
                    }
                } else {
                    displayAlert("Invalid URL: It should begin with http:// or https://")
                }
            } else {
                displayAlert("Invalid URL: It should begin with http:// or https://")
            }
        }
    }
    
    @IBAction func dismiss(sender: UIButton) {
        //dismiss parent modal
        presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func previewLink(sender: UIButton) {
        if let url = NSURL(string: addLinkTextView.text) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
                return
            }
        }
        displayAlert("Invalid URL: It should begin with http:// or https://")
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        previewLinkButton.hidden = true
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
            previewLinkButton.hidden = true
        } else {
            previewLinkButton.hidden = false
        }
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