//
//  CheckoutManager.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/7/12.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import Alamofire

struct CheckoutItems {
    var id: String
    var type: String
    var quantity: Int
}

struct Recipient {
    var phoneNumber: String
    var firstName: String
    var lastName: String
    var title: String
}

struct Shipping {
    var service: String
    var postalCode: String
    var city: String
    var address: String
}

struct Payment {
    var paymentMethod: String
    var number: String
    var expMonth: String
    var expYear: String
    var code: String
}

var responseID = ""
var transactionID = ""

func getCheckout(items: [CheckoutItems], recipient: [Recipient], shipping: [Shipping]) {

    let params: Parameters = [
        "items": [
            [
                "id": items[0].id,
                "type": "product",
                "quantity": items[0].quantity
            ]
        ],
        "recipient": [
            "phone_number": recipient[0].phoneNumber,
            "first_name": recipient[0].firstName,
            "last_name": recipient[0].lastName,
            "title": recipient[0].title
        ],
        "shipping": [
            "service": "post-office",
            "postal_code": shipping[0].postalCode,
            "city": shipping[0].city,
            "address": shipping[0].address
        ]
    ]

    Alamofire.request("http://52.198.40.72/patissier/api/v1/orders", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiI1OTRmN2Q3NmU2Y2I2MDE5ZWNjYjYwMTkiLCJleHAiOjE1MzAyNTE1MzUuNzI4LCJpYXQiOjE0OTg3MTU1MzUuNzI4NjcsImlzcyI6IjU5MjUxY2IxNDdkNTNiMDg1Y2EwNzY1NCIsInR5cGUiOiJhcHAiLCJ2ZXJzaW9uIjoiMS4wIn0.0jTCETh2yUzn7FJAG7-nRuY8UzjXyMJjojHQp_Y17iw"]).responseJSON { response in
        print(params)
        print(response)
        if let responseJSON = response.result.value, let downloadJSON = responseJSON as? [String: Any] {
            if let data = downloadJSON["data"] as? [String: Any] {
                if let id = data["id"] as? String {
                    responseID = id
                }
            }
        }
    }
}

func getTransaction(payment: [Payment]) {
    let params: Parameters = [
        "payment_method": "credit-card",
        "credit_card": [
            "number": payment[0].number,
            "expiration_month": payment[0].expMonth,
            "expiration_year": payment[0].expYear,
            "code": payment[0].code
        ]
    ]

    Alamofire.request("http://52.198.40.72/patissier/api/v1/orders/\(responseID)/transaction", method: .patch, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiI1OTRmN2Q3NmU2Y2I2MDE5ZWNjYjYwMTkiLCJleHAiOjE1MzAyNTE1MzUuNzI4LCJpYXQiOjE0OTg3MTU1MzUuNzI4NjcsImlzcyI6IjU5MjUxY2IxNDdkNTNiMDg1Y2EwNzY1NCIsInR5cGUiOiJhcHAiLCJ2ZXJzaW9uIjoiMS4wIn0.0jTCETh2yUzn7FJAG7-nRuY8UzjXyMJjojHQp_Y17iw"]).responseJSON { response in
        print(response)
        if let responseJSON = response.result.value, let downloadJSON = responseJSON as? [String: Any] {
            if let data = downloadJSON["data"] as? [String: Any] {
                if let id = data["transaction_id"] as? String {
                    transactionID = id
                    print(transactionID)
                }
            }
        }
    }

}
