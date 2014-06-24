//
//  TextToListTests.swift
//  TextToListTests
//
//  Created by Joseph on 11/06/2014.
//  Copyright (c) 2014 Human Friendly Ltd. All rights reserved.
//

import XCTest

func == <T:Equatable,U:Equatable>(lhs: (T,U), rhs: (T,U))->Bool {
    let (l0,l1) = lhs
    let (r0,r1) = rhs
    return l0 == r0 && l1 == r1
}

func == <T:Equatable,U:Equatable,V:Equatable>(lhs: (T,U,V), rhs: (T,U,V))->Bool {
    let (l0,l1,l2) = lhs
    let (r0,r1,r2) = rhs
    return l0 == r0 && l1 == r1 && l2 == r2
}

// Item1
// Item2
// - List1
//   L1Item1
//   L1Item2
// Item3"

class TextToListTests: XCTestCase {

    let testString1 = "Item1\nItem2\n- List1\n  L1Item1\n  L1Item2\nItem3"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSlices() {
        let a = [0,1,2,3,4,5,6,7,8,9]
        let b = a[2..a.count]
        XCTAssertEqual(b.count, 8)
        println(b)
        println(b.count)
        let c = b[2..b.count]
        println(c)
        XCTAssertEqual(c.count, 6)
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
    
    func testBuildTree() {
        var input:ListItemLine[] = []
        var (tree:ListContentItem[], errs:ParseError[]) = buildTree(input[0..0], 0)
        XCTAssertEqual(tree.count, 0)
        XCTAssert(errs.count == 0)
    }
    
    func testBuildTreeNonEmpty() {
        let inputPrep = multilineToListContentItems(testString1)
        var input:ListItemLine[] = inputPrep
        var (tree:ListContentItem[], errs:ParseError[]) = buildTree(input[0..input.count], 0)
        XCTAssert(tree.count == 4)
        XCTAssert(errs.count == 0)
        
    }
    
    func testMultilineToListContentsItems() {
        let lciArr = multilineToListContentItems(self.testString1)
        for l in lciArr {
           println("trimmed:'\(l.trimmedLine)' indent: \(l.indent)' isList? \(l.list)")
        }
    }
    
    func testItemLine() {
        var (it, err) = ItemLine(text: "blah").makeNode([])
        XCTAssertEqual(err.count, 0)
        XCTAssertEqual(it.name, "blah")
        
        var (lst, err2) = ItemLine(text: "- blah").makeNode([])
        XCTAssertEqual(err.count, 0)
        XCTAssertEqual(it.name, "blah")
    }
 
    func testParseMultilineText() {
        let (result, errors) = parseMultilineText(self.testString1)
        XCTAssertEqual(errors.count, 0)
        XCTAssertEqual(result[0].name,"Item1")
        //println(array2json(result))
    }
  
    func testPerformanceExample() {
        // This is an example of a performance test case.
        func repeatedPlus(base: String, count:Int)->String {
            var outstring = base
            for i in 1..count {
                outstring += base
            }
            return outstring
        }
        var result:ListContentItem[] = []
        var errors:ParseError[] = []
        let perfteststring = repeatedPlus(self.testString1, 100)
        self.measureBlock() {
            (result,errors) = parseMultilineText(perfteststring)
        }
    }
    func bodge(b: Int[]) {
        b[0] = 55
        println(b)
    }
    
    func testBuiltInCallModel() {
        let a = [1,2,3,4]
        bodge(a)
        XCTAssert(a == [1,2,3,4])
        a[3] = 7
        XCTAssert(a == [1,2,3,7])
        let b = [7,3,2,1]
        let c = sort(b)
        XCTAssert(c == a)
//        XCTAssert(b == [7,3,2,1])
    }
}
