//
//  DetailViewController.swift
//  YikYak
//
//  Created by Shrikar Archak on 1/6/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    var yak: PFObject?
    var commentView: UITextView?
    var footerView: UIView?
    var contentHeight: CGFloat = 0

    var comments: [String]?
    let FOOTERHEIGHT : CGFloat = 50;
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var yakLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
//        self.tableView.scrollsToTop = false

    }

    override func viewWillAppear(animated: Bool) {
        println("view will appear \(self.tableView.contentOffset)")
    }
    
    func keyBoardWillShow(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        
        var keyboardHeight:CGFloat =  keyboardSize.height - 40
        

        var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat
        
        var contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0);
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
    }
    
    func keyBoardWillHide(notification: NSNotification) {

        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "comments") {
//            let commentVC = segue.destinationViewController as CommentsTableViewController
//            commentVC.yak = yak
//        }
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as UITableViewCell
        
        //        cell.textLabel?.text = yak?.objectForKey("text") as String
        cell.textLabel?.text = "test"
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.footerView != nil {
            return self.footerView!.bounds.height
        }
        return FOOTERHEIGHT
    }

    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        println("view for footer \(self.tableView.contentOffset)")
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: FOOTERHEIGHT))
        footerView?.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
        commentView = UITextView(frame: CGRect(x: 10, y: 5, width: tableView.bounds.width - 80 , height: 40))
        commentView?.backgroundColor = UIColor.whiteColor()
        commentView?.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        commentView?.layer.cornerRadius = 2
        commentView?.scrollsToTop = true
        
        footerView?.addSubview(commentView!)
        let button = UIButton(frame: CGRect(x: tableView.bounds.width - 65, y: 10, width: 60 , height: 30))
        button.setTitle("Reply", forState: UIControlState.Normal)
        button.backgroundColor = UIColor(red: 155.0/255, green: 189.0/255, blue: 113.0/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: "reply", forControlEvents: UIControlEvents.TouchUpInside)
        footerView?.addSubview(button)
        commentView?.delegate = self
        println("TableView FRame -> FooterView Frame -> FooterView.bounds")
        println(self.tableView.frame)
        println(self.tableView.bounds)
        println(footerView?.frame)
        println(footerView?.bounds)
        println("==================")
        return footerView
    }
    
    override func viewDidLayoutSubviews() {
        println("Did layout subviews")
    }
    
    override func viewWillLayoutSubviews() {
        println("will layout subviews")
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        println("textViewDidBeginEditing \(self.tableView.contentOffset)")

    }
    
    func textViewDidChange(textView: UITextView) {
        
        
        if (contentHeight == 0) {
            contentHeight = commentView!.contentSize.height
        }
        
        if(commentView!.contentSize.height != contentHeight && commentView!.contentSize.height > footerView!.bounds.height) {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                let myview = self.footerView
                println(self.commentView!.contentSize.height)
                println(self.commentView?.font.lineHeight)
                let newHeight : CGFloat = self.commentView!.font.lineHeight
                let myFrame = CGRect(x: myview!.frame.minX, y: myview!.frame.minY - newHeight , width: myview!.bounds.width, height: newHeight + myview!.bounds.height)
                myview?.frame = myFrame
                
                let mycommview = self.commentView
                let newCommHeight : CGFloat = self.commentView!.contentSize.height
                let myCommFrame = CGRect(x: mycommview!.frame.minX, y: mycommview!.frame.minY, width: mycommview!.bounds.width, height: newCommHeight)
                mycommview?.frame = myCommFrame
                
                self.commentView = mycommview
                self.footerView  = myview
                
                for item in self.footerView!.subviews {
                    if(item.isKindOfClass(UIButton.self)){
                        let button = item as UIButton
                        let newY = self.footerView!.bounds.height / 2 - button.bounds.height / 2
                        let buttonFrame = CGRect(x: button.frame.minX, y: newY , width: button.bounds.width, height : button.bounds.height)
                        button.frame = buttonFrame
                        
                    }
                }
            })
            
            println(self.footerView?.frame)
            println(self.commentView?.frame)
            contentHeight = commentView!.contentSize.height
        }
        
        
    }
    
    func reply() {
        println(commentView?.text)
        yak?.addObject(commentView?.text, forKey: "comments")
        commentView?.text = ""
        self.commentView?.resignFirstResponder()
//        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        //self.tableView.reloadData()
//        self.tableView.setNeedsDisplay()
        
    }
}
