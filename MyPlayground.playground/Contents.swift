class A {
    
    let dataA = 3
    
    var b = B()
    
    func send () {
        
        b.dataB = dataA
        
    }
}



class B {
    
    var dataB = 0
    
}

var a = A()
a.send()
print(a.b.dataB)


var bv2 = B()
withUnsafePointer(to: &bv2) { print($0) }
withUnsafePointer(to: &a.b) { print($0) }