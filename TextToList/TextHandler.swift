//
//  TextHandler.swift
//  TextToList
//
//  Created by Joseph on 11/06/2014.
//  Copyright (c) 2014 Human Friendly Ltd. All rights reserved.
//

import Foundation

enum ContentType {
    case list, item
}

protocol ListContentItem {
    var name:String { get }
    var type:ContentType { get }
}



struct Item : ListContentItem {
    let name:String
    let notes:String = ""
    let quantity:String = ""
    let type = ContentType.item
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
    let type = ContentType.list
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
        (trimmedLine, indent, list) = _procLine(text)
    }
    func makeNode(lines: ListItemLine[])->(ListContentItem, ParseError[])  {
        if list {
            let (contents, errors) = buildTree(lines[1..lines.count], indent)
            return (List(name: trimmedLine, contents: contents), errors)
        } else {
            return (Item(name: trimmedLine),[])
        }
    }
}

struct ParseError {
    let line:Int?
    enum Reason {
        case badIndent
    }
}

func buildTree(lineArray:Slice<ListItemLine>, indentLevel:Int) -> (ListContentItem[],ParseError[]) {
    var ret_val:ListContentItem[] = []
    var parseErrors:ParseError[] = []
    var in_sublist = false
    var index = 0
    for line in lineArray {
        if (line.indent < indentLevel) { break }
        if (in_sublist && line.indent > indentLevel) { continue }
        if (in_sublist) { in_sublist = false }
        
    }
    return (ret_val, parseErrors)
}

func parseMultilineText(text:String, inout errors:ParseError[] ) -> ListContentItem[] {
    print(text)
    var lilArr:ListItemLine[] = []
    text.enumerateLines(){(line: String, inout stop: Bool)->() in lilArr.append(ItemLine(text: line))}
    let (ret:ListContentItem[],errors:ParseError[]) = buildTree(lilArr[0..lilArr.count], 0)
    return ret
}

