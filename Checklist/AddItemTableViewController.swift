//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Brian on 6/19/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
  
  func addItemViewControllerDidCancel(_ controller: AddItemTableViewController)
  
  func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem)
  
}

class AddItemTableViewController: UITableViewController {

  weak var delegate: AddItemViewControllerDelegate?
 // weak var todoList: TodoList?
 // weak var itemToEdit: ChecklistItem?
  
  @IBOutlet weak var addBarButton: UIBarButtonItem!
  @IBOutlet weak var todoName: UITextField!
  @IBOutlet weak var todoDescription: UITextField!
  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak var dueDate: UITextField!
  
  
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
    if let dueDateText = dueDate.text {
      item.dueDate = dueDateText
    }
    item.checked = false
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
