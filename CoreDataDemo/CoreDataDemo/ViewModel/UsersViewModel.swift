//
//  UserViewModel.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 28/06/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit

protocol UsersViewModelDelegate: class {
    func onUsersListFetched()
    func onFeedResponseFailed(_ error: String)
}

extension UsersViewModelDelegate {
    func onFeedResponseFailed(_ error: String) {
        
    }
}

class UsersViewModel {
    private var users = [Users]() {
        didSet {
            delegate?.onUsersListFetched()
        }
    }
    
    weak var delegate: UsersViewModelDelegate?
}

extension UsersViewModel {
    
    func fetchUsers() {
        DBHandler.fetchUsers { (users, error) in
            if let users = users {
                self.users = users
                self.delegate?.onUsersListFetched()
            } else {
                self.delegate?.onFeedResponseFailed("Failed to feetch users")
            }
        }
    }
}

extension UsersViewModel {
    func numberOfUsers() -> Int {
        return users.count
    }
    
    func user(for index: Int) -> Users {
        return users[index]
    }
    
    func removeUser(at index: Int) {
        users.remove(at: index)
    }
}
