//
//  UsersVC.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 28/06/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit

class UsersVC: UIViewController {
    
    @IBOutlet weak var uiTableView: UITableView!
    
    private var viewModel = UsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        uiTableView.delegate = self
        uiTableView.dataSource = self
        
        viewModel.fetchUsers()
    }
    
    @IBAction func onLogout(_ sender: Any) {
        AlertController.alert(title: AppConstants.logoutTitle, message: AppConstants.logoutSubTitle, buttons: ["No", "Yes"]) { (_, index) in
            if index == 1 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension UsersVC: UsersViewModelDelegate {
    
    func onUsersListFetched() {
        uiTableView.reloadData()
    }
    
    func onFeedResponseFailed(_ error: String) {
    
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UsersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        let user = viewModel.user(for: indexPath.row)
        cell.fTitle.text = user.username
        cell.fDescription.text = user.password
        
        if let dateStr = user.createdAt?.toString() {
          cell.createdAt.text = dateStr
        } else {
            cell.createdAt.text = ""
        }

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
            let user = viewModel.user(for: indexPath.row)
            DBHandler.delete(user)
            tableView.beginUpdates()
            viewModel.removeUser(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}
