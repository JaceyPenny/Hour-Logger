//
//  ViewController.swift
//  HourLogger
//
//  Created by Jace McPherson on 5/21/16.
//  Copyright © 2016 jacemcpherson. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
    
    var firebaseRef : FIRDatabaseReference?
    var itemsRef : FIRDatabaseReference?
    
    struct LogItem {
        var itemName : String
        var hours : Double
        var date : NSDate
    }

    var hoursList = [LogItem]()
    
    var updateFunction  = { (input : Double) in }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        // Load hours from Firebase
        
        firebaseRef = FIRDatabase.database().reference()
        itemsRef = firebaseRef!.child("items")
        
        itemsRef?.observeEventType(FIRDataEventType.ChildChanged, withBlock: {(snapshot) in
            print("Some data was updated for item \(snapshot.key)")
            
            let itemName = snapshot.key
            for i in 0...self.hoursList.count - 1 {
                if (self.hoursList[i].itemName == itemName) {
                    let values = snapshot.value as! [String: AnyObject]
                    self.updateListAt(i, itemName: itemName, hours: values["hours"] as! Double, date: NSDate(timeIntervalSince1970: values["date"] as! Double))
                    self.sortList()
                    self.tableView.reloadData()
                }
            }
        })
        
        itemsRef?.observeEventType(FIRDataEventType.ChildAdded, withBlock: {(snapshot) in
            let value = snapshot.value as! [String : AnyObject]
            
            let itemName = snapshot.key
            let hours = value["hours"] as! Double
            let date = NSDate(timeIntervalSince1970: value["date"] as! Double)
            
            self.appendToList(itemName, hours: hours, date: date)
            self.sortList()
            self.printList()
            self.tableView.reloadData()
        })
        
    }
    
    func sortList() {
        self.hoursList.sortInPlace({ (item1, item2) in
            if item1.date.compare(item2.date) == NSComparisonResult.OrderedAscending {
                return true
            } else {
                return false
            }
        })
    }
    
    func printList() {
        for item in hoursList {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy"
            print("\(item.itemName): Hours - \(item.hours), Date - \(formatter.stringFromDate(item.date))")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hoursList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        
        let hoursLabel = cell.viewWithTag(2) as! UILabel
        let dateLabel = cell.viewWithTag(3) as! UILabel
        
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        hoursLabel.text = numberFormatter.stringFromNumber(hoursList[indexPath.row].hours)! + " hours"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateLabel.text = dateFormatter.stringFromDate(hoursList[indexPath.row].date)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            itemsRef!.child(hoursList[indexPath.row].itemName).removeValue()
            removeFromListAt(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func appendToList(itemName:String, hours: Double, date : NSDate) {
        hoursList.append(LogItem(itemName: itemName, hours: hours, date: date))
        updateFunction(totalHours())
    }
    
    func updateListAt(index : Int, itemName : String, hours : Double, date : NSDate) {
        hoursList[index].itemName = itemName
        hoursList[index].hours = hours
        hoursList[index].date = date
        updateFunction(totalHours())
    }
    
    func removeFromListAt(index : Int) {
        hoursList.removeAtIndex(index)
        updateFunction(totalHours())
    }
    
    func totalHours() -> Double {
        var sum = 0.0
        for item in hoursList {
            sum += item.hours
        }
        return sum
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

