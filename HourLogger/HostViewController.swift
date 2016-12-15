//
//  HostViewController.swift
//  HourLogger
//
//  Created by Jace McPherson on 5/21/16.
//  Copyright © 2016 jacemcpherson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HostViewController : UIViewController {
    
    @IBOutlet var totalHoursLabel: UILabel!
    
    var viewController : ViewController?
    
    override func viewDidLoad() {
        setNeedsStatusBarAppearanceUpdate()
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName = segue.identifier
        if segueName == "tableViewEmbed" {
            viewController = segue.destinationViewController as? ViewController
            self.viewController!.updateFunction = { (input) in
                let formatter = NSNumberFormatter()
                formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                self.totalHoursLabel.text = "Total hours: \(formatter.stringFromNumber(input)!)"
            }
        }
    }
    
    func getItemsRef() -> FIRDatabaseReference?  {
        if viewController != nil {
            return viewController?.itemsRef
        } else {
            return nil
        }
    }
 
}
