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
    let placeholder = "Enter a Link to Share Here"
    var foundLocation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
            
        }
    }
    
    @IBAction func dismiss(sender: UIButton) {
        //dismiss parent modal
        presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
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