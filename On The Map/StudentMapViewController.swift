//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/4/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit
import MapKit

class StudentMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parameters = ["limit": 100, "order": "-updatedAt"]
        let task = ParseClient.sharedInstance().taskGetRequest(ParseClient.Methods.StudentLocation, parameters: parameters) { result, error in
            
            if let error = error {
                if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                    self.displayAlert(error.localizedDescription)
                } else {
                    self.displayAlert("Unable to show student location.")
                }
            } else {
                if let error = result.valueForKey("error") as? String {
                    self.displayAlert("Unable to show student location. (\(error))")
                } else {
                    for student in result.valueForKey("results") as! [[String: AnyObject]] {
                        let firstName = student["firstName"] as! String
                        let lastName = student["lastName"] as! String
                        let mediaURL = student["mediaURL"] as! String
                        let latitude = student["latitude"] as! Float
                        let longitude = student["longitude"] as! Float
                        let studentLocation = StudentLocation(firstName: firstName, lastName: lastName, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
                        ParseClient.sharedInstance().studentLocationList.append(studentLocation)
                    }
                    //TODO: plot pin
                }
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
}