enum Gender {
    case male
    case female
}

class Animal {
    var species: String = ""
    var age: Int = 0
    var gender = Gender.male
    func makeSounds() {
        print("")
    }
}

class Lion: Animal {
    override init() {
        super.init()
        species = "Lion"
        gender = Gender.male
        age = 3
    }
    override func makeSounds() {
        print("roar")
    }
}

class Cat: Animal {
    override init() {
        super.init()
        species = "Cat"
        gender = Gender.female
        age = 2
    }
    override func makeSounds() {
        print("meow")
    }
}

class Sheep: Animal {
    override init() {
        super.init()
        species = "Sheep"
        gender = Gender.female
        age = 4
    }
    override func makeSounds() {
        print("beep")
    }
}


class Zoo {
    var animals = [ Lion(), Cat(), Sheep() ]
    var maleAnimals: [String] = []
    var femaleAnimals: [String] = []
    
    func washAnimals() {
        for animal in animals {
            print("Washed \(animal.species)")
        }
    }
    func gdr() {
        for animal in animals {
            switch animal.gender {
            case Gender.male: maleAnimals.append(animal.species)
            case Gender.female: femaleAnimals.append(animal.species)
            }
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

zoo.gdr()
zoo.femaleAnimals
zoo.maleAnimals

//Closure完整寫法
let sortedZoo = zoo.animals.sorted(by: {(animal1, animal2) in
    return animal1.age > animal2.age
})
print(sortedZoo)

//let animalSorted = zoo.animals.sorted(by: {$0.age > $1.age})
//print(animalSorted)







