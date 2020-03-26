//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Field Employee on 3/23/20.
//

import Foundation
import RealmSwift

class ChecklistItem: Object {
  
  @objc dynamic var text = ""
  @objc dynamic var descrip = ""
  @objc dynamic var dueDate: Date
  @objc dynamic var checked = false
  @objc dynamic var urgent = false
  
  
  required init() {
    dueDate = Date()
  }
 
 
  func toggleChecked() {
    checked = !checked
  }
  
}
