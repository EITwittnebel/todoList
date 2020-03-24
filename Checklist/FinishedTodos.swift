//
//  FinishedTodos.swift
//  Checklist
//
//  Created by Field Employee on 3/23/20.
//  Copyright © 2020 Razeware. All rights reserved.
//

import UIKit

class FinishedTodos: UITableViewController {
  
  var completedTodos: TodoList
  
  required init?(coder aDecoder: NSCoder) {
    completedTodos = TodoList()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
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

