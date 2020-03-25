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
  
  func editItemViewController(_ controller: AddItemTableViewController, didFinishEditting item: ChecklistItem)
  
  func addItemViewControllerComplete(_ controller: AddItemTableViewController, item: FinishedItem)
  
}

class AddItemTableViewController: UITableViewController {

  weak var delegate: AddItemViewControllerDelegate?
 // weak var todoList: TodoList?
  var itemToEdit: ChecklistItem?
  var test: Int?
  
  let realm = try! Realm()
  lazy var categories: Results<ChecklistItem> = { self.realm.objects(ChecklistItem.self) }()
  
  @IBOutlet weak var addBarButton: UIBarButtonItem!
  @IBOutlet weak var todoName: UITextField!
  @IBOutlet weak var todoDescription: UITextField!
  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak var dueDate: UIDatePicker!

  
  @IBAction func cancel(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    delegate?.addItemViewControllerDidCancel(self)
  }
  
  @IBAction func done(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    let item: ChecklistItem = itemToEdit ?? ChecklistItem()
    try! realm.write () {
      if let nameFieldText = todoName.text {
        item.text = nameFieldText
      }
      if let descripFieldText = todoDescription.text {
        item.descrip = descripFieldText
      }
      item.dueDate = dueDate.date
      item.checked = false

      if (itemToEdit == nil) {
        realm.add(item)
      }
    }
    if (itemToEdit == nil) {
      delegate?.addItemViewController(self, didFinishAdding: item)
    } else {
      delegate?.editItemViewController(self, didFinishEditting: item)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(test ?? 0)
    if (itemToEdit != nil) {
      todoName.text = itemToEdit!.text
      todoDescription.text = itemToEdit!.descrip
      addBarButton.isEnabled = true
      title = "Edit Item"
    } else {
      title = "Add Item"
    }
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
