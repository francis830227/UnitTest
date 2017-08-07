import PlaygroundSupport
import Dispatch
PlaygroundPage.current.needsIndefiniteExecution = true

let queue1 = DispatchQueue(label: "com.appcoda.queue1", qos: DispatchQoS.userInitiated)
//let queue2 = DispatchQueue(label: "com.appcoda.queue2", qos: DispatchQoS.userInitiated)
//let queue2 = DispatchQueue(label: "com.appcoda.queue2", qos: DispatchQoS.utility)
//let queue2 = DispatchQueue(label: "com.appcoda.queue2", qos: DispatchQoS.background)
let queue2 = DispatchQueue(label: "com.appcoda.queue2", qos: DispatchQoS.default)

queue1.async {
    for i in 0..<10 {
        print("🌕", i)
    }
}

queue2.async {
    for i in 100..<110 {
        print("🔴", i)
    }
}
