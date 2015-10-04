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
    
    @IBOutlet weak var addLinkTextView: UITextView!
    let placeholder = "Enter a Link to Share Here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        addLinkTextView.text = placeholder
        addLinkTextView.textColor = UIColor.lightGrayColor()
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
    
    @IBAction func dismiss(sender: UIButton) {
        //dismiss parent modal
        presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}