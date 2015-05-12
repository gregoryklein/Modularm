//
//  TimelineDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 4/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class TimelineDataSource: NSObject
{
   // MARK: - Instance Variables
   @IBOutlet weak var collectionView: UICollectionView!
   @IBOutlet weak var timelineController: TimelineController!
   
   private let coreDataStack = CoreDataStack.defaultStack

   lazy var fetchedResultsController: NSFetchedResultsController =
   {
      let coreDataStack = CoreDataStack.defaultStack

      let fetchRequest = NSFetchRequest(entityName: "Alarm")
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "fireDateValue", ascending: true)];

      let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

      controller.performFetch(nil)
      controller.delegate = self

      return controller
   }()
   
   func removeIncompleteAlarms()
   {
      if let alarms = self.fetchedResultsController.fetchedObjects as? [Alarm]
      {
         for alarm in alarms
         {
            if !alarm.completedSetup
            {
               CoreDataStack.deleteObject(alarm)
            }
         }
      }
   }

   // MARK: - Public
   func reloadData()
   {
      self.collectionView.reloadData()
   }
}

extension TimelineDataSource: UICollectionViewDelegate
{
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
   {
      let alarmEntry: Alarm = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Alarm
      self.timelineController.openSettingsForAlarm(alarmEntry)
   }
}

// MARK: - UICollectionView Data Source
extension TimelineDataSource: UICollectionViewDataSource
{
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   {
      let objects = self.fetchedResultsController.fetchedObjects
      let count = objects?.count
      println("\(count!) alarms")

      return count!
   }

   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
   {
      let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell

      let alarmEntry: Alarm = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Alarm
      
      
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "YYYY MMM d, hh:mm aa"
      
      let prettyAlarmDate = dateFormatter.stringFromDate(alarmEntry.fireDate)
      println("Alarm date is set for: \(prettyAlarmDate)")

      return cell
   }
}

// MARK: - NSFetchedResultsController Delegate
extension TimelineDataSource: NSFetchedResultsControllerDelegate
{
   func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
   {
      if type != NSFetchedResultsChangeType.Insert
      {
         self.reloadData()
      }
   }
}
