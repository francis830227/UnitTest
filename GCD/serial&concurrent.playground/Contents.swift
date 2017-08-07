import PlaygroundSupport
import Dispatch
PlaygroundPage.current.needsIndefiniteExecution = true

//let queue = DispatchQueue(label: "abc", qos: .utility)
let queue = DispatchQueue(label: "abc", qos: .utility, attributes: .concurrent)

queue.async {
    for i in 0..<10 {
        print("🌕", i)
    }
}

queue.async {
    for i in 100..<110 {
        print("🔴", i)
    }
}

queue.async {
    for i in 1000..<1010 {
        print("⚪️", i)
    }
}
