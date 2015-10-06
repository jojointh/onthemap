//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/7/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import UIKit

// MARK: - Convenient Resource Methods

extension ParseClient {

    func getStudentLocation(completionHandler: (studentLocationList: [[String: AnyObject]]?, errorString: String?) -> Void) {
        let parameters = ["limit": 100, "order": "-updatedAt"]
        let task = ParseClient.sharedInstance().taskGetRequest(ParseClient.Methods.StudentLocation, parameters: parameters) { result, error in
            if let error = error {
                if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                    completionHandler(studentLocationList: nil, errorString: error.localizedDescription)
                } else {
                    completionHandler(studentLocationList: nil, errorString: "Unable to show student location.")
                }
            } else {
                if let error = result.valueForKey("error") as? String {
                    completionHandler(studentLocationList: nil, errorString: "Unable to show student location. (\(error))")
                } else {
                    completionHandler(studentLocationList: result.valueForKey("results") as? [[String: AnyObject]], errorString: nil)
                }
            }
        }
    }

    func postStudentLocation(parameters: [String: AnyObject], completionHandler: (success: Bool, errorString: String?) -> Void) {
        ParseClient.sharedInstance().taskPostRequest(ParseClient.Methods.StudentLocation, postParams: parameters) {
            result, error in
            if let error = error {
                if error.domain == NSURLErrorDomain || error.domain == "parsingJSON" {
                    completionHandler(success: false, errorString: error.localizedDescription)
                } else {
                    completionHandler(success: false, errorString: "Could no save location.")
                }
            } else {
                if let error = result.valueForKey("error") as? String {
                    completionHandler(success: false, errorString: error)
                } else {
                    completionHandler(success: true, errorString: nil)
                }
            }
        }
    }
}