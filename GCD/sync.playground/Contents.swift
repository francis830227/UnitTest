import PlaygroundSupport
import Dispatch
PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "abc")

queue.sync {
    for i in 0..<10 {
        print("🌕", i)
    }
}

for i in 100..<110 {
    print("Ⓜ️", i)
}
