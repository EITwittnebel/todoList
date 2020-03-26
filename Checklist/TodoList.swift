//
//  TodoList.swift
//  Checklist
//
//  Created by Field Employee on 3/23/20.
//

import Foundation

class TodoList {
  
  var todos: [ChecklistItem] = []

  public init() {
    
    let row0Item = ChecklistItem()
    let row1Item = ChecklistItem()
    let row2Item = ChecklistItem()
    let row3Item = ChecklistItem()
    let row4Item = ChecklistItem()
    
    row0Item.text = "Take a jog"
    row0Item.descrip = "test"
    row1Item.text = "Watch a movie"
    row2Item.text = "Code an app"
    row3Item.text = "Walk the dog"
    row4Item.text = "Study design patterns"
    
    todos.append(row0Item)
    todos.append(row1Item)
    todos.append(row2Item)
    todos.append(row3Item)
    todos.append(row4Item)
    
  }
  
  func newTodo() -> ChecklistItem {
    let item = ChecklistItem()
    item.text = randomTitle()
    item.checked  = true
    todos.append(item)
    return item
  }
  
  private func randomTitle() -> String {
    var titles = ["New todo item", "Generic todo", "Fill me out", "I need something to do", "Much todo about nothing"]
    let randomNumber = Int.random(in: 0 ... titles.count - 1)
    return titles[randomNumber]
  }
  
}

extension Collection where Iterator.Element == TodoList
{
    // Builds the persistence URL. This is a location inside
    // the "Application Support" directory for the App.
    private static func persistencePath() -> URL?
    {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)

        return url?.appendingPathComponent("todoitems.bin")
    }

    // Write the array to persistence
    func writeToPersistence() throws
    {
        if let url = Self.persistencePath(), let array = self as? NSArray
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        }
        else
        {
            throw NSError(domain: "com.example.MyToDo", code: 10, userInfo: nil)
        }
    }

    // Read the array from persistence
    static func readFromPersistence() throws -> [TodoList]
    {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [TodoList]
            {
                return array
            }
            else
            {
                throw NSError(domain: "com.example.MyToDo", code: 11, userInfo: nil)
            }
        }
        else
        {
            throw NSError(domain: "com.example.MyToDo", code: 12, userInfo: nil)
        }
    }
}
