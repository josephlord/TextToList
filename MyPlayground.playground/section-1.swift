// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
v.backgroundColor = UIColor.blueColor()

let v2 = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

v2.backgroundColor = UIColor.whiteColor()
v.addSubview(v2)

v2.frame = CGRect(x: 70, y: 0, width: 30, height: 30)

func nilString()->String? {
    return "Hello"
}

if var s:String = nilString() {
    s.isEmpty
    s
}
let s = nilString()

let b = s?.isEmpty


let arr = [1,"b",3, "a"]

//let f = arr[1] + 5

if let x = arr[1] as? Int {
    x + 5
} else if let x = arr[3] as? String {
    x + " - is a string"
}

NSLog("nslog")

func multiR()->(String, Float) {
    return ("string", 5.0)
}

let (st, i) = multiR()


func == <T:Equatable,U:Equatable>(lhs: (T,U), rhs: (T,U)) -> Bool {
    let (l0,l1) = lhs
    let (r0,r1) = rhs
    return l0 == r0 && l1 == r1
}


("string", 5.0) == multiR()


