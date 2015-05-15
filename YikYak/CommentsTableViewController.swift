//
//  CommentsTableViewController.swift
//  YikYak
//
//  Created by Shrikar Archak on 1/6/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController, UITextViewDelegate {

    var commentView: UITextView?
    var footerView: UIView?
    var contentHeight: CGFloat = 0
    var yak: PFObject?
    var comments: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        println(yak?.objectForKey("comments"))
        
        if(yak?.objectForKey("comments") != nil) {
            comments = yak?.objectForKey("comments") as! [String]
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        if let count = comments?.count {
//            return count
//        }
        return 15
    }

//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if self.footerView != nil {
//            return self.footerView!.bounds.height
//        }
//        return 50
//    }
//
//    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        println("Footerview")
//        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
//        footerView?.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
//        commentView = UITextView(frame: CGRect(x: 10, y: 5, width: tableView.bounds.width - 80 , height: 40))
//        commentView?.backgroundColor = UIColor.whiteColor()
//        commentView?.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
//        commentView?.layer.cornerRadius = 2
//        commentView?.scrollsToTop = true
//        
//        footerView?.addSubview(commentView!)
//        let button = UIButton(frame: CGRect(x: tableView.bounds.width - 65, y: 10, width: 60 , height: 30))
//        button.setTitle("Reply", forState: UIControlState.Normal)
//        button.backgroundColor = UIColor(red: 155.0/255, green: 189.0/255, blue: 113.0/255, alpha: 1)
//        button.layer.cornerRadius = 5
//        button.addTarget(self, action: "reply", forControlEvents: UIControlEvents.TouchUpInside)
//        footerView?.addSubview(button)
//        commentView?.delegate = self
//        println(self.tableView.frame)
//        println(self.footerView?.frame)
//        println(self.footerView?.bounds)
//        return footerView
//    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.footerView != nil {
            return self.footerView!.bounds.height
        }
        return 50
    }
    

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        println("Footerview")
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
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
        println(self.tableView.frame)
        println(self.footerView?.frame)
        println(self.footerView?.bounds)
        return footerView
    }


    func textViewDidBeginEditing(textView: UITextView) {
       self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)

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
                        let button = item as! UIButton
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
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)

    }

    


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = comments![indexPath.row]
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
