//
//  ViewController.swift
//  Taskmaster
//
//  Created by Jaden Hong on 2022-01-23.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var listOfTasks = [Task]()
    
    var selectedTitle : Category? {
        didSet { 
            load()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - tableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        listOfTasks[indexPath.row].done = !listOfTasks[indexPath.row].done
        save()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - tableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listCellId, for: indexPath)
        let task = listOfTasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = .black
        content.text = task.title
        
        cell.accessoryType = task.done ? .checkmark : .none
        
        cell.contentConfiguration = content

        return cell
    }
    
    // MARK: - tableView Data Manipulation Methods

    func save() {
        do {
            try context.save()
        } catch {
            print("Error thrown -> saving core data : \(error)")
        }
        tableView.reloadData()
    }
    
    func load(_ request : NSFetchRequest<Task> = Task.fetchRequest()) {
        
        request.predicate = NSPredicate(format: "parentCategory.title MATCHES %@", selectedTitle!.title!)
        
        do {
            listOfTasks = try context.fetch(request)
        } catch {
            print("Error thrown -> loading core data : \(error)")
        }
         
    }
    
    func del(_ indexPath: IndexPath) {
        context.delete(listOfTasks[indexPath.row])
        listOfTasks.remove(at: indexPath.row)
        save()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: K.deleteActionTitleSwipe) { action, view, handler in
            self.del(indexPath)
        } 
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
     
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: K.listAlertControllerTitle, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.listAlertActionTitle, style: .default) { action in
            
            let newTask = Task(context: self.context)
            newTask.title = textField.text!
            newTask.done = false
            newTask.parentCategory = self.selectedTitle
            
            self.listOfTasks.append(newTask)
            self.save()
        }
        alert.addTextField { field in
            field.placeholder = K.listAlertFieldPlaceholder
            textField = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

