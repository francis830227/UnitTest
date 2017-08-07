enum Gender {
    case male
    case female
}

enum FoodType {
    case carnivores //肉食
    case herbivores //草食
    case onmivores  //雜食
}

protocol Characteristics {
    var foodType: FoodType { get }
}

class Animal: Characteristics {
    var species: String = ""
    var age: Int = 0
    var gender = Gender.male
    var foodType = FoodType.onmivores
    init() {
    }
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
        foodType = FoodType.carnivores
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
        foodType = FoodType.herbivores
    }
    override func makeSounds() {
        print("beep")
    }
}


class Zoo {
    var animals = [ Lion(), Cat(), Sheep() ]
    var maleAnimals: [String] = []
    var femaleAnimals: [String] = []
    
    init() {}
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

let animalSorted = zoo.animals.sorted(by: {$0.age > $1.age})
print(animalSorted)







