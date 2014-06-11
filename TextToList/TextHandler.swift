//
//  TextHandler.swift
//  TextToList
//
//  Created by Joseph on 11/06/2014.
//  Copyright (c) 2014 Human Friendly Ltd. All rights reserved.
//

import Foundation

struct Item {
    let name:String
    let notes:String? = nil
    let quantity:String? = nil
    
    init(name: String) {
        self.name = name
    }
    init(name: String, notes: String?, quantity: String?) {
        self.name = name
        self.notes = notes
        self.quantity = quantity
    }
}