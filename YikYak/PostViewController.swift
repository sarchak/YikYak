//
//  PostViewController.swift
//  YikYak
//
//  Created by Shrikar Archak on 12/31/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {

    var reset:Bool = false
    
    @IBOutlet weak var postView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.postView.selectedRange = NSMakeRange(0, 0);
        self.postView.delegate = self
        self.postView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    
    @IBAction func postPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    func textViewDidChange(textView: UITextView) {
        if(reset == false){
            self.postView.text = String(Array(self.postView.text)[0])
            reset = true
        }   
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
