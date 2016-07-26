//
//  Extensions.swift
//  Notes
//
//  Created by Joshua Fisher on 7/26/16.
//  Copyright © 2016 Calendre Co. All rights reserved.
//

import Foundation

// http://stackoverflow.com/a/30593673/313295
extension CollectionType {
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}