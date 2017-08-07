import UIKit

let appworksArray = ["AppWorks", "School", "Rocks"]//---------Ans(1)



var filterdAppworksArray = [String]()

func filterContentForSearchText(searchText: String) {
    filterdAppworksArray = appworksArray.filter { item in
        return item.lowercased().contains(searchText.lowercased())
    }
}

filterContentForSearchText(searchText: "a")
print(filterdAppworksArray)//----------------------------------Ans(2)



var countAppworksArray = appworksArray.map { item in
    return item.characters.count
}

print(countAppworksArray)//------------------------------------Ans(3)



var combineAppworksArray = appworksArray.reduce("") {
    return $0 + $1 + " "
}

print(combineAppworksArray)//----------------------------------Ans(4)
