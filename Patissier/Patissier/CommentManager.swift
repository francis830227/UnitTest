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

struct ProductComment {
    var id: String
    var productID: String
    var text: String
    var userID: String
    var userName: String
}

protocol CommentManagerDelegate: class {

    func manager(_ manager: CommentManager, didGet products: [ProductComment])

    func manager(_ manager: CommentManager, didFailWith error: Error)

}

class CommentManager {

    var productComment = [ProductComment]()

    var urlComment = ""

    var nextComment = ""

    let token = UserDefaults.standard.string(forKey: "jwt")!

    static let shared = CommentManager()

    weak var delegate: CommentManagerDelegate?

    func requestComments(productID: String) {
        print("-------requestComment\(productID)----------")
        let url = URL(string: "http://52.198.40.72/patissier/api/v1/products/\(productID)/comments\(self.urlComment)")!
        Alamofire.request(url, method: .get, headers: ["Authorization": "Bearer \(token)"]).responseJSON { response in
            DispatchQueue.global().async {
                if let responseJSON = response.result.value {
                    if let downloadJSON = responseJSON as? [String: Any] {
                        if let productCommentData = downloadJSON["data"] as? [[String: Any]] {
                            for comment in productCommentData {
                                if let id = comment["id"] as? String, let productID = comment["product_id"] as? String, let text = comment["text"] as? String, let user = comment["user"] as? [String: Any] {
                                    if let userID = user["id"] as? String, let userName = user["name"] as? String {
                                        self.productComment.append(ProductComment(id: id, productID: productID, text: text, userID: userID, userName: userName))
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                self.delegate?.manager(self, didGet: self.productComment)
                            }
                        }
                        if let downloadPaging = downloadJSON["paging"] as? [String: Any] {
                            if let secondPaging = downloadPaging["next"] as? String {
                                self.nextComment = secondPaging
                                self.urlComment = "?paging=\(self.nextComment)"
                            }
                        }
                    }
                }
            }
            }.resume()
    }
}
