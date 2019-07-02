//
//  UserBooks.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 02/07/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit
import CoreData

class UserBooks: UIViewController {
    
    @IBOutlet weak var uiTableView: UITableView!
    
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiTableView.delegate = self
        uiTableView.dataSource = self
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension UserBooks: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        print("books>> \(book.users)")

    }
    
    func configureCell(_ cell: UserCell, at indexPath: IndexPath) {
        // Fetch Note
        let book = books[indexPath.row]
        
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

extension UserBooks: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        uiTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        uiTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {}
    
}
