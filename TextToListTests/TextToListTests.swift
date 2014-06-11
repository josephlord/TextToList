//
//  TextToListTests.swift
//  TextToListTests
//
//  Created by Joseph on 11/06/2014.
//  Copyright (c) 2014 Human Friendly Ltd. All rights reserved.
//

import XCTest

class TextToListTests: XCTestCase {
    
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
        XCTAssert(it.name == itemname)
    }
    
    func testSplitLines() {
        let stringWith3Lines = "zero\none\ntwo"
        var stringArray: String[] = []
        stringWith3Lines.enumerateLines({(line:String, inout stop:Bool)->() in stringArray.append(line)})
        XCTAssert(stringArray.count == 3)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
