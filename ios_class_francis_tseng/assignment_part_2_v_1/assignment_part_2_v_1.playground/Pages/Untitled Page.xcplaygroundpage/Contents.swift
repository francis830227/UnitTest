
class Animal {
    var names: String = "Animal"
    let species: String = ""
    var age: Int = 0
    func makeSounds() {
        print("")
    }
}

class Lion: Animal {
    override init() {
        super.init()
        names = "Lion"
        age = 3
    }
    override func makeSounds() {
        print("roar")
    }
}

class Cat: Animal {
    override init() {
        super.init()
        names = "Cat"
        age = 2
    }
    override func makeSounds() {
        print("meow")
    }
}

class Sheep: Animal {
    override init() {
        super.init()
        names = "Sheep"
        age = 4
    }
    override func makeSounds() {
        print("beep")
    }
}


class Zoo {
    let animals = [ Lion(), Cat(), Sheep() ]
    
    func washAnimals() {
        for animal in animals {
            print("Washed \(animal.names)")
        }
    }
}

let lion = Lion()
lion.makeSounds()
lion.age


let cat = Cat()
cat.makeSounds()
cat.age

let sheep = Sheep()
sheep.makeSounds()
sheep.age

let zoo = Zoo()
zoo.washAnimals()




