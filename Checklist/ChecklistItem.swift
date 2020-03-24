//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Brian on 6/19/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation
import RealmSwift

class ChecklistItem: Object {
  /*
  required init?(coder aDecoder: NSCoder) {
    if let text = aDecoder.decodeObject(forKey: "text") as? String {
      self.text = text
    } else {
      return nil
    }
    
    if let descrip = aDecoder.decodeObject(forKey: "descrip") as? String {
      self.descrip = descrip
    } else {
      return nil
    }
    
    if aDecoder.containsValue(forKey: "checked")
    {
        self.checked = aDecoder.decodeBool(forKey: "checked")
    } else {
      return nil
    }
    
    if let dueDate = aDecoder.decodeObject(forKey: "due") as? Date {
      self.dueDate = dueDate
    } else {
      return nil
    }
  }
  
  func encode(with aCoder: NSCoder)
  {
    // Store the objects into the coder object
    aCoder.encode(self.text, forKey: "text")
    aCoder.encode(self.descrip, forKey: "descrip")
    aCoder.encode(self.checked, forKey: "checked")
    aCoder.encode(self.dueDate, forKey: "due")
  }
  */
  
  @objc dynamic var text = ""
  @objc dynamic var descrip = ""
  @objc dynamic var dueDate: Date
  @objc dynamic var checked = false
  
  
  required init() {
    dueDate = Date()
  }
 
 
  func toggleChecked() {
    checked = !checked
  }
  
}
 
/*
extension Collection where Iterator.Element == ChecklistItem
{
    // Builds the persistence URL. This is a location inside
    // the "Application Support" directory for the App.
    private static func persistencePath() -> URL?
    {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)

        return url?.appendingPathComponent("todoitems.bin")
    }

    // Write the array to persistence
    func writeToPersistence() throws
    {
        if let url = Self.persistencePath(), let array = self as? NSArray
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        }
        else
        {
            throw NSError(domain: "com.example.MyToDo", code: 10, userInfo: nil)
        }
    }

    // Read the array from persistence
    static func readFromPersistence() throws -> [ChecklistItem]
    {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ChecklistItem]
            {
                return array
            }
            else
            {
                throw NSError(domain: "com.example.MyToDo", code: 11, userInfo: nil)
            }
        }
        else
        {
            throw NSError(domain: "com.example.MyToDo", code: 12, userInfo: nil)
        }
    }
}
*/


