//
//  AlarmConfigurationController.swift
//  Modularm
//
//  Created by Gregory Klein on 4/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class AlarmConfigurationController: UIViewController
{
   // MARK: - Instance Variables
   @IBOutlet weak var alarmOptionsHeightConstraint: NSLayoutConstraint!
   @IBOutlet weak var alarmOptionsControllerBottomVerticalSpaceConstraint: NSLayoutConstraint!
   @IBOutlet weak var segmentedControl: UISegmentedControl!
   var alarmTimeController: AlarmTimeController?
   var alarmOptionsController: AlarmOptionsController?
   var alarm: Alarm?

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerUpForNotification:", name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveAlarmOptionsControllerDownForNotification:", name: UIKeyboardWillHideNotification, object: nil)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated);

      self.segmentedControl.selectedSegmentIndex = 1
      self.segmentedControl.enabled = false
      self.segmentedControl.userInteractionEnabled = false
   }

   // MARK: - Public
   func moveAlarmOptionsControllerUpForNotification(notification: NSNotification)
   {
      if let info = notification.userInfo
      {
         let keyboardBoundsValue = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
         let keyboardBounds = keyboardBoundsValue.CGRectValue()
         let height = CGRectGetHeight(keyboardBounds)

         UIView.animateWithDuration(0.25, animations: {() -> Void in
            self.alarmOptionsControllerBottomVerticalSpaceConstraint.constant = height
            self.view.layoutIfNeeded()
         })
      }
   }

   func moveAlarmOptionsControllerDownForNotification(notification: NSNotification)
   {
      if let info = notification.userInfo
      {
         UIView.animateWithDuration(0.25, animations: {() -> Void in
            self.alarmOptionsControllerBottomVerticalSpaceConstraint.constant = 0
            self.view.layoutIfNeeded()
         })
      }
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if segue.identifier == "alarmTimeControllerSegue"
      {
         self.alarmTimeController = segue.destinationViewController as? AlarmTimeController
      }
      else if segue.identifier == "alarmOptionsControllerSegue"
      {
         self.alarmOptionsController = segue.destinationViewController.childViewControllers![0] as? AlarmOptionsController
      }
   }
}
