//
//  StudentInfomation.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/4/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float

    init(dictionary: [String:AnyObject]) {
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? "http://www.udacity.com"
        self.latitude = dictionary["latitude"] as? Float ?? 0.0
        self.longitude = dictionary["longitude"] as? Float ?? 0.0
    }
    
    func getDictionary() -> [String:AnyObject] {
        return ["uniqueKey": self.uniqueKey,
            "firstName": self.firstName,
            "lastName": self.lastName,
            "mediaURL": self.mediaURL,
            "latitude": self.latitude,
            "longitude": self.longitude]
    }
}

class AppData: NSObject {

    var userInfomation = StudentInformation(dictionary: [String:AnyObject]())
    var studentInformationList = [StudentInformation]()

    class func sharedInstance() -> AppData {
        struct Singleton {
            static var sharedInstance = AppData()
        }
        return Singleton.sharedInstance
    }
}
