//
//  GeneralExtension.swift
//  CoreDataDemo
//
//  Created by raj.sharma on 01/07/19.
//  Copyright © 2019 raj.sharma. All rights reserved.
//

import UIKit

extension Date {
    func toString(_ format: String = "dd MMM yy, HH:mm:ss") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
