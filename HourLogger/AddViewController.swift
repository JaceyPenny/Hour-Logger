//
//  AddViewController.swift
//  HourLogger
//
//  Created by Jace McPherson on 5/21/16.
//  Copyright © 2016 jacemcpherson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddViewController : UIViewController {
    
    @IBOutlet var hoursTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func addClicked(sender: UIButton) {
        let viewController = navigationController!.viewControllers[navigationController!.viewControllers.count - 2] as! HostViewController
        
        
        let newItem : FIRDatabaseReference = viewController.getItemsRef()!.childByAutoId()
        let logItem : NSDictionary = ["hours" : Double(hoursTextField.text!)!,
                                      "date" : datePicker.date.timeIntervalSince1970 as Double]
        newItem.setValue(logItem)
        navigationController!.popViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func valueChanged(sender: AnyObject) {
        self.view.endEditing(true)
    }
}
