//
//  TextToListTests.swift
//  TextToListTests
//
//  Created by Joseph on 11/06/2014.
//  Copyright (c) 2014 Human Friendly Ltd. All rights reserved.
//

import XCTest


func == <T:Equatable,U:Equatable,V:Equatable>(lhs: (T,U,V), rhs: (T,U,V))->Bool {
    let (l0,l1,l2) = lhs
    let (r0,r1,r2) = rhs
    return l0 == r0 && l1 == r1 && l2 == r2
}

class TextToListTests: XCTestCase {

    let testString1 = "Item1\nItem2\nList1\n  L1Item1\n  L1Item2\nItem3"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testItem() {
        let itemname = "Iname"
        let it = Item(name: itemname)
        XCTAssertEqual(it.name, itemname)
    }
    
    func testSplitLines() {
        let stringWith3Lines = "zero\none\ntwo"
        var stringArray: String[] = []
        stringWith3Lines.enumerateLines({(line:String, inout stop:Bool)->() in stringArray.append(line)})
        XCTAssert(stringArray.count == 3)
        XCTAssert(stringArray == ["zero", "one","two"])
    }
    
    func test_procLine() {
        XCTAssert(_procLine("blah") == ("blah", 0, false))
        XCTAssert(_procLine("- foo") == ("foo", 2, true))
        XCTAssert(_procLine("  boo") == ("boo", 2, false))
        XCTAssert(_procLine("  - boom") == ("boom", 4, true))
    }
    
    func testItemLine() {
        var item:Item, list:List
        var (it, err) = ItemLine(text: "blah").makeNode([])
        XCTAssertEqual(err.count, 0)
        XCTAssertEqual(it.name, "blah")
   /*     (it, err) = ItemLine(text: "- blah").makeNode([])
        XCTAssertEqual(err.count, 0)
        XCTAssertEqual(it.name, "blah")*/
    }
   /*
    func testParseMultilineText() {
        var errors:ParseError[] = []
        let result: ListContentItem[] = parseMultilineText(self.testString1, &errors)
        XCTAssertEqual(errors.count, 0)
        XCTAssertEqual(result[0].name,"Item1")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        var errors:ParseError[] = []
        self.measureBlock() {
            let result: ListContentItem[] = parseMultilineText(self.testString1, &errors)
        }
    }
    */
}
