//
//  ParseClient.swift
//  On The Map
//
//  Created by Surasak Adulprasertsuk on 10/4/15.
//  Copyright (c) 2015 Surasak. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    /* Shared session */
    var session: NSURLSession

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    func taskGetRequest (methods: String, parameters: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.BaseURL + methods + ParseClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        var jsonifyError: NSError? = nil
        
        let task = session.dataTaskWithRequest(request) {
            data, response, errorRequest in
            if let error = errorRequest {
                completionHandler(result: nil, error: error)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    
    func taskPostRequest (methods: String, postParams: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.BaseURL + methods
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        request.addValue(Constants.appID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(postParams, options: nil, error: &jsonifyError)
        
        let task = session.dataTaskWithRequest(request) {
            data, response, errorRequest in
            if let error = errorRequest {
                completionHandler(result: nil, error: error)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            let thisError = NSError(domain: "parsingJSON", code: 0, userInfo: [NSLocalizedDescriptionKey : "Invalid data return from server"])
            completionHandler(result: nil, error: thisError)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
}