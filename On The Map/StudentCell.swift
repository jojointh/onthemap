//
//  StudentCell.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/5/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit
import MapKit

class StudentCell: UITableViewCell {
    
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var tableView: UITableViewController? = nil
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func showMap(sender: UIButton) {
        activityIndicator.startAnimating()
        var address = ""
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            let placeArray = placemarks as? [CLPlacemark]
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            
            // Location name
            if let locationName = placeMark.addressDictionary["Name"] as? NSString {
                address += (locationName as String) + " "
            }
            
            // Street address
            if let street = placeMark.addressDictionary["Thoroughfare"] as? NSString {
                address += (street as String) + " "
            }
            
            // City
            if let city = placeMark.addressDictionary["City"] as? NSString {
                address += (city as String) + " "
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary["ZIP"] as? NSString {
                address += (zip as String) + " "
            }
            
            // Country
            if let country = placeMark.addressDictionary["Country"] as? NSString {
                address += (country as String) + " "
            }
            
            if address.isEmpty {
                address = "Unknown"
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
            }
            let alert = UIAlertController(title: "", message: address, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.tableView?.presentViewController(alert, animated: true, completion: nil)
        })
        
    }
}
