//
//  TextHandler.swift
//  TextToList
//
//  Created by Joseph on 11/06/2014.
//  Copyright (c) 2014 Human Friendly Ltd. All rights reserved.
//

import Foundation

protocol ListContentItem {
    var name:String { get }
}

struct Item : ListContentItem {
    let name:String
    let notes:String = ""
    let quantity:String = ""
    init(name: String) {
        self.name = name
    }
    init(name: String, notes: String, quantity: String) {
        self.name = name
        self.notes = notes
        self.quantity = quantity
    }
}

struct List : ListContentItem {
    let contents:ListContentItem[]
    let name:String
    init(name:String, contents: ListContentItem[]) {
        self.name = name
        self.contents = contents
    }
}

protocol ListItemLine {
    var indent:Int { get }
    var rawLine:String { get }
    var trimmedLine:String { get }
    var list:Bool { get }
}

// Used in ItemLine init. Returns trimmed string, indent int, islist bool as a tuple
func _procLine(line:String)->(String,Int,Bool) {
    var i = 0
    for c in line {
        if (c != " ") { break }
        ++i
    }
    var trimmed = line.substringFromIndex(i)
    var isList = false
    if trimmed.hasPrefix("- ") {
        isList = true
        i += 2
    }
    return (line.substringFromIndex(i),i, isList)
}

struct ItemLine : ListItemLine {
    let rawLine:String
    let trimmedLine:String
    let indent:Int
    let list:Bool
    
    init(text:String) {
        rawLine = text
        var tl:String
        var idnt:Int
        var lst:Bool
        (tl, idnt, lst) = _procLine(text)
        trimmedLine = tl
        indent = idnt
        list = lst
    }
}

struct ParseError {
    let line:Int
    enum Reason {
        case badIndent
    }
}

func parseMultilineText(text:String, inout errors:ParseError[] ) -> ListContentItem[] {
    
    var lilArr:ListItemLine[] = []
    text.enumerateLines(){(line: String, inout stop: Bool)->() in lilArr.append(ItemLine(text: line))}
    
    return [Item(name: "dummy")]
}

