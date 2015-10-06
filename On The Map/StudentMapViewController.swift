//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/4/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit

class StudentMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var annotations = [MKPointAnnotation]()
        ParseClient.sharedInstance().getStudentLocation() {
            studentLocationList, errorString in
            if let studentLocationList = studentLocationList {
                for student in studentLocationList {
                    let studentInformation = StudentInformation(studentInfomation: student)
                    AppData.sharedInstance().studentInformationList.append(studentInformation)
                    
                    // create annotation point
                    let lat = CLLocationDegrees(studentInformation.latitude)
                    let long = CLLocationDegrees(studentInformation.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let first = studentInformation.firstName
                    let last = studentInformation.lastName
                    let mediaURL = studentInformation.mediaURL
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    annotations.append(annotation)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(annotations)
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
    
    // MARK: - MKMapViewDelegate
    
    // customize pin and annotation
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
}