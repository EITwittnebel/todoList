//
//  FinishedTodos.swift
//  Checklist
//
//  Created by Field Employee on 3/23/20.
//

import UIKit
import RealmSwift

class FinishedTodos: UITableViewController {
  
  var reload: Int = 0
  
  let realm = try! Realm()
  lazy var categories2: Results<FinishedItem> = { self.realm.objects(FinishedItem.self) }()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    //reload = true
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
    super.viewWillAppear(animated)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories2.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (reload != categories2.count) {
      tableView.reloadData()
      reload = categories2.count
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "FinishedItem", for: indexPath)
    try! realm.write() {
      let item = categories2[indexPath.row]
      configureText(for: cell, with: item)
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let indexPaths = [indexPath]
    try! realm.write() {
      realm.delete(categories2[indexPath.row])
    }
    tableView.deleteRows(at: indexPaths, with: .automatic)
    tableView.reloadData()
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

