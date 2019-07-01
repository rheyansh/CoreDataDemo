//
//  UsersVC.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 28/06/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit
import CoreData

class UsersVC: UIViewController {
    
    @IBOutlet weak var uiTableView: UITableView!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Users> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
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
        AlertController.alert(title: AppConstants.logoutTitle, message: AppConstants.logoutSubTitle, buttons: ["No", "Yes"]) { (_, index) in
            if index == 1 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension UsersVC: UITableViewDataSource, UITableViewDelegate {
    
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
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            //let user = viewModel.user(for: indexPath.row)
            let user = fetchedResultsController.object(at: indexPath)

            DBHandler.delete(user)
            tableView.reloadData()
        }
    }
    
    func configureCell(_ cell: UserCell, at indexPath: IndexPath) {
        // Fetch Note
        let user = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.fTitle.text = user.username
        cell.fDescription.text = user.password
        
        if let dateStr = user.createdAt?.toString() {
            cell.createdAt.text = dateStr
        } else {
            cell.createdAt.text = ""
        }
    }
}

extension UsersVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        uiTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        uiTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                uiTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                uiTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = uiTableView.cellForRow(at: indexPath) as? UserCell {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                uiTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                uiTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
            
        }
    }
    
}
