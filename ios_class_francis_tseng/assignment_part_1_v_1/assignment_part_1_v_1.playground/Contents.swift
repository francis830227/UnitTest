class Animal {
    let species: String
    init(_ speciesInside: String) {
        self.species = speciesInside
    }
    func makeSounds() {
        print("")
    }
}


class Lion: Animal {
    override func makeSounds() {
        print("roar")
    }
}


class Cat: Animal {
    override func makeSounds() {
        print("meow")
    }
}


class Sheep: Animal {
    override func makeSounds() {
        print("beep")
    }
}

let lion = Lion.init("Big cat")
lion.makeSounds()
let cat = Cat.init("Cat")
cat.makeSounds()

let sheep = Sheep.init("Sheep")
sheep.makeSounds()
