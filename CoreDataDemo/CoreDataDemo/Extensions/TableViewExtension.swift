//
//  TableViewExtension.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 28/06/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    public func dequeueReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error for cell if: \(identifier) at \(indexPath)")
        }
        return cell
    }
}

class GenericTableViewCell<View: UIView>: UITableViewCell {
    
    var cellView: View? {
        
        didSet {
            setUpViews()
        }
    }
    
    func setUpViews() {
        guard let cellView = cellView else { return }
        addSubview(cellView)
        cellView.pinEdgesToSuperview()
    }
}

extension UIView {
    func pinEdgesToSuperview() {
        
    }
}
