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

    init(studentInfomation: [String:AnyObject]) {
        self.uniqueKey = studentInfomation["uniqueKey"] as? String ?? ""
        self.firstName = studentInfomation["firstName"] as? String ?? ""
        self.lastName = studentInfomation["lastName"] as? String ?? ""
        self.mediaURL = studentInfomation["mediaURL"] as? String ?? "http://www.udacity.com"
        self.latitude = studentInfomation["latitude"] as? Float ?? 0.0
        self.longitude = studentInfomation["longitude"] as? Float ?? 0.0
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