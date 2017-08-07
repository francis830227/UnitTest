//
//  ProductManager.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/6/29.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct Product {
    var name: String
    var price: Double
    var id: String
}

protocol ProductManagerDelegate: class {

    func manager(_ manager: ProductManager, didGet products: [Product])

    func manager(_ manager: ProductManager, didFailWith error: Error)

}

class ProductManager {

    var productsPM = [Product]()

    var urlPage = ""

    var nextPage = ""

    let token = UserDefaults.standard.string(forKey: "jwt")!

    static let shared = ProductManager()

    weak var delegate: ProductManagerDelegate?

    func requestProducts() {
        print("--------request")

        let url = URL(string: "http://52.198.40.72/patissier/api/v1/products\(urlPage)")!
        Alamofire.request(url, method: .get, headers: ["Authorization": "Bearer \(token)"]).responseJSON { response in
            if let responseJSON = response.result.value {
                if let downloadJSON = responseJSON as? [String: Any] {
                    if let productData = downloadJSON["data"] as? [[String: Any]] {//as? Array<[String: Any]> {
                        for product in productData {
                            if let price = product["price"] as? Double, let name = product["name"] as? String, let id = product["id"] as? String {
                                self.productsPM.append(Product(name: name, price: price, id: id))
                            }
                        }
                        DispatchQueue.main.async {
                            self.delegate?.manager(self, didGet: self.productsPM)
                        }
                    }
                    if let downloadPaging = downloadJSON["paging"] as? [String: String] {
                        if let secondPaging = downloadPaging["next"] {
                            self.nextPage = secondPaging
                            self.urlPage = "?paging=\(self.nextPage)"
                        }
                    }
                }
            }
            }.resume()
    }
}
