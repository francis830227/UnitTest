//
//  ProfileManager.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/7/6.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct Profile {
    var orderID: String
    var items: [Items]
    var buyerID: String
    var recipientPhoneNumber: String
    var recipientFirstName: String
    var recipientLastName: String
    var recipientTitle: String
    var shippingService: String
    var shippingPostalCode: String
    var shippingCity: String
    var shippingAddress: String
    var totalAmount: Int
    var transactionID: String
    var transactionPaymentMethod: String
    var createdTime: String
}

struct Items {
    var itemID = ""
    var itemType = ""
    var itemQuantity = 0
}

protocol ProfileManagerDelegate: class {

    func manager(_ manager: ProfileManager, didGet profiles: [Profile])

    func manager(_ manager: ProfileManager, didFailWith error: Error)

}

class ProfileManager {

    enum RequestProductsError: Error {
        case invalidResponsDownCasting
    }

    var orderID = ""
    var items = [Items]()
    var buyerID = ""
    var recipientPhoneNumber = ""
    var recipientFirstName = ""
    var recipientLastName = ""
    var recipientTitle = ""
    var shippingService = ""
    var shippingPostalCode = ""
    var shippingCity = ""
    var shippingAddress = ""
    var totalAmount = 0
    var transactionID = ""
    var transactionPaymentMethod = ""
    var createdTime = ""

    var profiles = [Profile]()

    var urlPage = ""

    var nextPage = ""

    let token = UserDefaults.standard.string(forKey: "jwt")!

    static let shared = ProfileManager()

    weak var delegate: ProfileManagerDelegate?

    func requestProfiles() {
        print("--------request-------------------")

        let url = URL(string: "http://52.198.40.72/patissier/api/v1/me/orders\(urlPage)")!
        Alamofire.request(url, method: .get, headers: ["Authorization": "Bearer \(token)"]).responseJSON { response in
            if let responseJSON = response.result.value, let downloadJSON = responseJSON as? [String: Any] {
                if let productData = downloadJSON["data"] as? [[String: Any]] {//as? Array<[String: Any]> {
                    for element in productData {
                        self.orderID = element["id"] as? String ?? "no orderID"
                        if let itemsData = element["items"] as? [[String: Any]] {
                            for item in itemsData {
                                if let id = item["id"] as? String, let type = item["type"] as? String, let quantity = item["quantity"] as? Int {
                                    self.items.append(Items(itemID: id, itemType: type, itemQuantity: quantity))
                                }
                            }
                        }
                        if let buyer = element["buyer"] as? [String: Any] {
                            self.buyerID = buyer["id"] as? String ?? "no buyerID"
                        }
                        if let recipient = element["recipient"] as? [String: Any] {
                            self.recipientPhoneNumber = recipient["phone_number"] as? String ?? "no phoneNumber"
                            self.recipientFirstName = recipient["first_name"] as? String ?? "no firstName"
                            self.recipientLastName = recipient["last_name"] as? String ?? "no lastName"
                            self.recipientTitle = recipient["title"] as? String ?? "no title"
                        }
                        if let shipping = element["shipping"] as? [String: Any] {
                            self.shippingService = shipping["service"] as? String ?? "no service"
                            self.shippingPostalCode = shipping["postal_code"] as? String ?? "no postalCode"
                            self.shippingCity = shipping["city"] as? String ?? "no city"
                            self.shippingAddress = shipping["address"] as? String ?? "no address"
                        }
                        self.totalAmount = element["total_amount"] as? Int ?? 404
                        if let transaction = element["transaction"] as? [String: Any] {
                            self.transactionID = transaction["id"] as? String ?? "no transID"
                            self.transactionPaymentMethod = transaction["payment_method"] as? String ?? "no paymentMethod"
                        }
                        self.createdTime = element["created"] as? String ?? "no createdTime"

                        self.profiles.append(Profile(orderID: self.orderID, items: self.items, buyerID: self.buyerID, recipientPhoneNumber: self.recipientPhoneNumber, recipientFirstName: self.recipientFirstName, recipientLastName: self.recipientLastName, recipientTitle: self.recipientTitle, shippingService: self.shippingService, shippingPostalCode: self.shippingPostalCode, shippingCity: self.shippingCity, shippingAddress: self.shippingAddress, totalAmount: self.totalAmount, transactionID: self.transactionID, transactionPaymentMethod: self.transactionPaymentMethod, createdTime: self.createdTime))
                        print(self.profiles)
                        DispatchQueue.main.async {
                            self.delegate?.manager(self, didGet: self.profiles)
                        }
                        
                    }
//                    self.profiles.append(Profile(orderID: self.orderID, items: self.items, buyerID: self.buyerID, recipientPhoneNumber: self.recipientPhoneNumber, recipientFirstName: self.recipientFirstName, recipientLastName: self.recipientLastName, recipientTitle: self.recipientTitle, shippingService: self.shippingService, shippingPostalCode: self.shippingPostalCode, shippingCity: self.shippingCity, shippingAddress: self.shippingAddress, totalAmount: self.totalAmount, transactionID: self.transactionID, transactionPaymentMethod: self.transactionPaymentMethod, createdTime: self.createdTime))
//                    print(self.profiles)
//                    DispatchQueue.main.async {
//                        self.delegate?.manager(self, didGet: self.profiles)
//                    }
                    print("success")
                }
                    if let downloadPaging = downloadJSON["paging"] as? [String: String], let secondPaging = downloadPaging["next"] {
                            self.nextPage = secondPaging
                            self.urlPage = "?paging=\(self.nextPage)"
                        }
                }
            }.resume()
    }
}
