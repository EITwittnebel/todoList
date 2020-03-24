//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Field Employee on 3/23/20.
//

import UIKit
import RealmSwift

protocol AddItemViewControllerDelegate: class {
  
  func addItemViewControllerDidCancel(_ controller: AddItemTableViewController)
  
  func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem)
  
  func addItemViewControllerComplete(_ controller: AddItemTableViewController, didFinishCompleting item: ChecklistItem)
  
}

class AddItemTableViewController: UITableViewController {

  weak var delegate: AddItemViewControllerDelegate?
 // weak var todoList: TodoList?
 // weak var itemToEdit: ChecklistItem?
  
  let realm = try! Realm()
  lazy var categories: Results<ChecklistItem> = { self.realm.objects(ChecklistItem.self) }()
  
  @IBOutlet weak var addBarButton: UIBarButtonItem!
  @IBOutlet weak var todoName: UITextField!
  @IBOutlet weak var todoDescription: UITextField!
  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak var dueDate: UIDatePicker!
  
  @IBAction func completeButton(_ sender: Any) {
    //navigationController?.popViewController(animated: true)
    let item = ChecklistItem()
    if let nameFieldText = todoName.text {
      item.text = nameFieldText
    }
    if let descripFieldText = todoDescription.text {
      item.descrip = descripFieldText
    }
    item.dueDate = dueDate.date
    item.checked = true
    delegate?.addItemViewControllerComplete(self, didFinishCompleting: item)
  }
  
  @IBAction func cancel(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    delegate?.addItemViewControllerDidCancel(self)
  }
  
  @IBAction func done(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    let item = ChecklistItem()
    if let nameFieldText = todoName.text {
      item.text = nameFieldText
    }
    if let descripFieldText = todoDescription.text {
      item.descrip = descripFieldText
    }
    item.dueDate = dueDate.date
    item.checked = false
    try! realm.write () {
      realm.add(item)
    }
    delegate?.addItemViewController(self, didFinishAdding: item)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
  }
  
  override func viewWillAppear(_ animated: Bool) {
    todoName.becomeFirstResponder()
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
}

extension AddItemTableViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let oldText = textField.text,
          let stringRange = Range(range, in: oldText) else {
      return false
    }
    
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    
    if newText.isEmpty {
      addBarButton.isEnabled = false
    } else {
      addBarButton.isEnabled = true
    }
      
    return true
  }
  
}
