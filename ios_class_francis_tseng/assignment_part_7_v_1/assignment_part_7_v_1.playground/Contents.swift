var addTwoClosure1: (Int, Int) -> Int = {
    (a: Int, b: Int) in
    let sum = a + b
    return sum
}

var addTwoClosure2: (Int, Int) -> Int = {
    (a, b) in
    let sum = a + b
    return sum
}

var addTwoClosure3: (Int, Int) -> Int = {
    (a, b) in a + b
}

var addTwoClosure4 = {$0 + $1}(3, 4)




addTwoClosure1(3, 4)

addTwoClosure2(3, 4)

addTwoClosure3(3, 4)

addTwoClosure4


