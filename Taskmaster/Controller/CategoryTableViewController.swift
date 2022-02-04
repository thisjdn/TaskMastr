//
//  CategoryTableViewController.swift
//  Taskmaster
//
//  Created by Jaden Hong on 2022-01-23.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate  as! AppDelegate).persistentContainer.viewContext
      
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarTitle()
        loadCategories()
    }
    
    // MARK: - NavBar Methods
    
    func navBarTitle() {
        let navController = navigationController!
        let image = UIImage(imageLiteralResourceName: "taskmastrTitle")
        
        let width = navController.navigationBar.frame.size.width
        let height = navController.navigationBar.frame.size.height
        let x = width/2 - (image.size.width)/2
        let y = height/2 - (image.size.height)/2
        
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellId, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = categories[indexPath.row].title
        content.textProperties.color = .black
        
        cell.contentConfiguration = content
        
        return cell
    }
 
    // MARK: - tableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItemsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow { 
            destinationVC.selectedTitle = categories[indexPath.row]
        }
        
    }
    
    // MARK: - tableView Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error w/ saveCategories : \(error)")
        }
        loadCategories()
    }
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error w/ loadCategories : \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteCategories(_ indexPath: IndexPath) {
        context.delete(categories[indexPath.row])
        categories.remove(at: indexPath.row)
        saveCategories()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { 
        let deleteAction = UIContextualAction(style: .destructive, title: K.deleteActionTitleSwipe) { action, view, handler in
            self.deleteCategories(indexPath) 
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
/*
    query : read and request
    request : NSFetchRequest
    NSPredicate(Format: )
    request.predicate = predicate
*/
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: K.categoryAlertControllerTitle, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.categoryAlertActionTitle, style: .default) { action in
             
            let newEntry = Category(context: self.context)
            newEntry.title = textField.text!
            
            self.categories.append(newEntry)
            self.saveCategories()
        }
        alert.addTextField { field in
            field.placeholder = K.categoryAlertFieldPlaceholder
            textField = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
