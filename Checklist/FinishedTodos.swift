//
//  FinishedTodos.swift
//  Checklist
//
//  Created by Field Employee on 3/23/20.
//

import UIKit
import RealmSwift

class FinishedTodos: UITableViewController {
  
  var completedTodos: TodoList
  
  let realm = try! Realm()
  lazy var categories2: Results<ChecklistItem> = { self.realm.objects(ChecklistItem.self) }()
  
  required init?(coder aDecoder: NSCoder) {
    completedTodos = TodoList()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    //print(categories2.count)
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return completedTodos.todos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
     let item = completedTodos.todos[indexPath.row]
     return cell
   }
  
  
}

