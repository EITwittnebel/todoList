//
//  FinishedTodos.swift
//  Checklist
//
//  Created by Field Employee on 3/23/20.
//

import UIKit
import RealmSwift

class FinishedTodos: UITableViewController {
  
  let realm = try! Realm()
  lazy var categories2: Results<FinishedItem> = { self.realm.objects(FinishedItem.self) }()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    //print(categories2.count)
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories2.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "FinishedItem", for: indexPath)
     try! realm.write() {
       let item = categories2[indexPath.row]
       configureText(for: cell, with: item)
     }
     return cell
   }
  
  func configureText(for cell: UITableViewCell, with item: FinishedItem) {
    if let label = cell.viewWithTag(1500) as? UILabel {
      label.text = item.text
    }
    if let label = cell.viewWithTag(1501) as? UILabel {
      label.text = item.descrip
    }
  }
}

