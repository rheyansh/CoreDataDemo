//
//  BooksVC.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 02/07/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit
import CoreData

class BooksVC: UIViewController {
    
    @IBOutlet weak var uiTableView: UITableView!
    
    var users = [Users]()
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DBConstants.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiTableView.delegate = self
        uiTableView.dataSource = self
        DBHandler.fetchUsers({ (users, error) in
            if let users = users {
                self.users = users
            }
        })
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        //viewModel.fetchUsers()
    }
    
    @IBAction func onLogout(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension BooksVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = fetchedResultsController.object(at: indexPath)

        let userNames = users.map { (user) -> String in
            return (user.username ?? "")
        }
        
        AlertController.actionSheet(title: "Add to user", message: "", sourceView: self.view, buttons: userNames) { (action, index) in
            let user = self.users[index]
            book.addToUsers(user)
            AlertController.alert(title: "\(String(describing: book.title)) added to \(String(describing: user.username))")
            DBHandler.saveContext()
        }
    }
    
    func configureCell(_ cell: UserCell, at indexPath: IndexPath) {
        // Fetch Note
        let book = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.fTitle.text = book.title
        cell.fDescription.text = book.desc
        
        if let dateStr = book.publishedAt?.toString() {
            cell.createdAt.text = dateStr
        } else {
            cell.createdAt.text = ""
        }
    }
}

extension BooksVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        uiTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        uiTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {}
    
}
