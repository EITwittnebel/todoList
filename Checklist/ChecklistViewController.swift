//
//  ViewController.swift
//  Checklist
//
//  Created by Field Employee on 3/23/20.
//

import UIKit
import Foundation
import RealmSwift

class ChecklistViewController: UITableViewController {
  
  var todoList: TodoList
  
  let realm = try! Realm()
  lazy var categories: Results<ChecklistItem> = { self.realm.objects(ChecklistItem.self) }()
  
  @IBOutlet weak var urgentPic: UIImageView!
  
  private func populateDefaultCategories() {
    if categories.count == 0 { // 1
      print("categories populated")
      try! realm.write() { // 2
        let defaultCategories =
          ["Birds", "Mammals", "Flora", "Reptiles", "Arachnids" ] // 3
        
        for category in defaultCategories { // 4
          let newCategory = ChecklistItem()
          newCategory.text = category
          newCategory.checked = false
          
          realm.add(newCategory)
        }
      }
      
      categories = realm.objects(ChecklistItem.self) // 5
    } else {
      print("nani")
    }/*else {
      try! realm.write() {
        print("categories purged")
        for item in categories {
          realm.delete(item)
        }
      }
    }*/
  }
  

  
  @IBAction func completeButton(_ sender: UIButton) {
    //navigationController?.popViewController(animated: true)
    let item = FinishedItem()
    guard let cell = sender.superview?.superview as? UITableViewCell,
      let indexPath = tableView.indexPath(for: cell) else {
        return
      }
    item.text = categories[indexPath.row].text
    item.descrip = categories[indexPath.row].descrip
    try! realm.write() {
      realm.add(item)
      realm.delete(categories[indexPath.row])
    }
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
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
/* REALLY DOESNT LIKE THIS
    for item in realm.objects(ChecklistItem.self) {
      if (item.checked == false) {
        todoList.todos.append(item)
      }
    }
  */
    navigationController?.navigationBar.prefersLargeTitles = true
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categories.count
    //return todoList.todos.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    try! realm.write() {
      let item = categories[indexPath.row]
    
      //let item = todoList.todos[indexPath.row]
      configureText(for: cell, with: item)
      //urgentButton.isHidden = true
      configureCheckmark(for: cell, with: item)
    }
    if categories[indexPath.row].urgent {
      //let imageView = UIImageView()
      //imageView.frame = CGRect(x: cell.center.x-25, y: cell.center.y-30, width: 15, height: 15)
      //imageView.backgroundColor = .cyan
      //cell.addSubview(imageView)
    }
    return cell
  }
 

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //if let cell = tableView.cellForRow(at: indexPath) {
      //try! realm.write() {
      //  let item = categories[indexPath.row]
      //}
      //configureCheckmark(for: cell, with: item)
      tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //todoList.todos.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    try! realm.write() {
      //categories[indexPath.row].checked = true
      realm.delete(categories[indexPath.row])
    }
    let subviews = tableView.cellForRow(at: indexPath)?.subviews
    //for view in subviews! {
    //  view.removeFromSuperview()
    //}
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
      if (item.dueDate < Date()) {
        label.textColor = .red
      }
    }
  }
  
  func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    guard let urgentMark = cell.viewWithTag(9001) as? UILabel else { return }
    if item.urgent {
      urgentMark.text = "⚠️"
    } else {
      urgentMark.text = ""
    }
    item.toggleChecked()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let sb: UITableViewController = storyboard?.instantiateViewController(withIdentifier: "Completed") as? UITableViewController {
      sb.tableView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
    super.viewWillAppear(animated)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "addItemSegue" {
      if let addItemViewController = segue.destination as? AddItemTableViewController {
        addItemViewController.delegate = self
        //addItemViewController.todoList = todoList
      }
    }
    if segue.identifier == "editItemSegue" {
      if let addItemViewController = segue.destination as? AddItemTableViewController {
        if let cell = sender as? UITableViewCell,
          let indexPath = tableView.indexPath(for: cell) {
            let item: ChecklistItem = categories[indexPath.row]
            addItemViewController.itemToEdit = item
            addItemViewController.test = 5
            addItemViewController.delegate = self
        }
      }
    }
  }
}

extension ChecklistViewController: AddItemViewControllerDelegate {
  func addItemViewControllerComplete(_ controller: AddItemTableViewController, item: FinishedItem) {
    navigationController?.popViewController(animated: true)
    tableView.reloadData()
  }
  
  func editItemViewController(_ controller: AddItemTableViewController, didFinishEditting item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    tableView.reloadData()
  }
  
  func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    
    let newRowIndex = categories.count - 1
    //todoList.todos.append(item)
       
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)

  }
  
}
