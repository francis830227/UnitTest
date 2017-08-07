//
//  myProfileManager.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/7/7.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import Alamofire

struct MyProfile {
    var firstName: String
    var myID: String
    var lastName: String
    var name: String
}

protocol MyProfileManagerDelegate: class {
    func manager(_ manager: MyProfileManager, didGet myProfiles: [MyProfile])

    func manager(_ manager: MyProfileManager, didFailWith error: Error)
}

class MyProfileManager {
    enum RequestProductsError: Error {
        case invalidResponsDownCasting
    }

    let token = UserDefaults.standard.string(forKey: "jwt")!

    var myProfile = [MyProfile]()

    static let shared = MyProfileManager()

    weak var delegate: MyProfileManagerDelegate?

    func requestMyProfiles() {
        let url = URL(string: "http://52.198.40.72/patissier/api/v1/me")!
        Alamofire.request(url, method: .get, headers: ["Authorization": "Bearer \(token)"]).responseJSON { response in
            if let responseJSON = response.result.value, let downloadJSON = responseJSON as? [String: Any] {
                if let profileData = downloadJSON["data"] as? [String: Any] {
                    if let id = profileData["id"] as? String,
                        let firstName = profileData["first_name"] as? String,
                        let lastName = profileData["last_name"] as? String,
                        let name = profileData["name"] as? String {
                        self.myProfile.append(MyProfile(firstName: firstName, myID: id, lastName: lastName, name: name))
                    }
                }
                self.delegate?.manager(self, didGet: self.myProfile)
                print(self.myProfile)
            }
        }.resume()
    }
}
