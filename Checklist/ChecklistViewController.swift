//
//  ViewController.swift
//  Checklist
//
//  Created by Brian on 6/18/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit
import Foundation

class ChecklistViewController: UITableViewController {

  var todoList: TodoList
  
  @IBAction func addItem(_ sender: Any) {
    
    let newRowIndex = todoList.todos.count
    _ = todoList.newTodo()
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    todoList = TodoList()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.todos.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    let item = todoList.todos[indexPath.row]
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)
    
    return cell
  }
 

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = todoList.todos[indexPath.row]
      configureCheckmark(for: cell, with: item)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    todoList.todos.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
    
  
  
  func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    if let label = cell.viewWithTag(1000) as? UILabel {
      label.text = item.text
    }
    if let label = cell.viewWithTag(999) as? UILabel {
      label.text = item.descrip
    }
    if let label = cell.viewWithTag(998) as? UILabel {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "hh:mm, MM/dd"
      label.text = dateFormatter.string(from: item.dueDate)
    }
  }
  
  func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    if item.checked {
      cell.accessoryType = .disclosureIndicator
    } else {
      cell.accessoryType = .disclosureIndicator
    }
    item.toggleChecked()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "addItemSegue" {
      if let addItemViewController = segue.destination as? AddItemTableViewController {
        addItemViewController.delegate = self
        //addItemViewController.todoList = todoList
      }
    }
    /*
    if segue.identifier == "editItemSegue" {
      if let addItemViewController = segue.destination as? AddItemTableViewController {
        if let cell = sender as? UITableViewCell,
          let indexPath = tableView.indexPath(for: cell) {
          let item = todoList.todos[indexPath.row]
          addItemViewController.itemToEdit = item
        }
      }*
    }*/
  }
}

extension ChecklistViewController: AddItemViewControllerDelegate {
  func addItemViewControllerComplete(_ controller: AddItemTableViewController, didFinishCompleting item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
  }
  
  
  func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    
    let newRowIndex = todoList.todos.count
    todoList.todos.append(item)
       
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)

  }
  
}
