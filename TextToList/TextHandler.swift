//
//  TextHandler.swift
//  TextToList
//
//  Created by Joseph on 11/06/2014.
//  Copyright (c) 2014 Human Friendly Ltd. All rights reserved.
//

import Foundation

func least <T:Comparable>(a:T , b:T)->T {
    return (a < b ? a : b)
}

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
    var lineNo:Int? { get set }
    func makeNode(lines: Slice<ListItemLine>) -> (ListContentItem, ParseError[])
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
    var lineNo:Int? = nil
    init(text:String) {
        rawLine = text
        (trimmedLine, indent, list) = _procLine(text)
    }
    func makeNode(lines: Slice<ListItemLine>)->(ListContentItem, ParseError[])  {
        if list {
            let (contents, errors) = buildTree(lines[least(1,lines.count)..lines.count], indent)
            return (List(name: trimmedLine, contents: contents), errors)
        } else {
            return (Item(name: trimmedLine),[])
        }
    }
}

struct ParseError {
    let line:Int?
    let linePos:Int?
    
    let reason = Reason.badIndent
    enum Reason {
        case badIndent
    }
    init(line:Int?) {
        self.line = line
    }
}

func buildTree(lineArray:Slice<ListItemLine>, indentLevel:Int)
        -> (ListContentItem[],ParseError[]) {
    var ret_val:ListContentItem[] = []
    var parseErrors:ParseError[] = []
    var in_sublist = false
    var nextIndex = 0
    for line in lineArray {
        ++nextIndex
        if (line.indent < indentLevel) { break } // Outdent compared to us. Escape and let caller deal with it
        if (in_sublist && line.indent > indentLevel + 1) { continue }
        if (in_sublist && line.indent == indentLevel + 1) {
            parseErrors.append(ParseError(line: nil));
            continue
        }
        // At this point either we weren't in a sublist or were but are back at this level's indentation level
        let (node,errors) = line.makeNode(lineArray[least(nextIndex, lineArray.count)..lineArray.count])
        in_sublist = node.type == ContentType.list
        ret_val.append(node)
        parseErrors += errors
    }
    return (ret_val, parseErrors)
}

func multilineToListContentItems(text:String)->ListItemLine[]
{
    var lciArr:ListItemLine[] = []
    text.enumerateLines(){(line: String, inout stop: Bool)->() in lciArr.append(ItemLine(text: line))}
    var i = 1
    for (var line) in lciArr {
        line.lineNo = i++
    }
    return lciArr
}

func parseMultilineText(text:String) -> (ListContentItem[],ParseError[]) {
    let lciArr = multilineToListContentItems(text)
    return buildTree(lciArr[0..lciArr.count], 0)
}

