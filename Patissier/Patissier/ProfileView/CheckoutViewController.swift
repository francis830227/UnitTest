//
//  CheckoutViewController.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/7/10.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit

let cityPicker = UIPickerView()
let titlePicker = UIPickerView()
let expMonthPicker = UIPickerView()
let expYearPicker = UIPickerView()

class CheckoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var shippingCityBottomView: UIView!
    @IBOutlet weak var recipientTitleBottomView: UIView!
    @IBOutlet weak var paymentExpMonthBottomView: UIView!
    @IBOutlet weak var paymentExpYearBottomView: UIView!

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperNumber: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cardTextField: UITextField!
    @IBOutlet weak var expMonthTextField: UITextField!
    @IBOutlet weak var expYearTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var backItem: UIBarButtonItem!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var bottomView: UIView!

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        var totalAmount = 0.0
        stepperNumber.text = Int(sender.value).description
        totalAmount = productPriceFromSegue * Double(stepperNumber.text!)!
        total.text = "$\(productPriceFromSegue) x \(Int(stepperNumber.text!) ?? 0) = \(totalAmount)"

    }
    @IBAction func purshase(_ sender: UIButton) {
        items.append(CheckoutItems(id: productIDFromSegue, type: "product", quantity: Int(stepperNumber.text!)!))
        recipients.append(Recipient(phoneNumber: phoneTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, title: titleTextField.text!))
        shippings.append(Shipping(service: "post-office", postalCode: postalCodeTextField.text!, city: cityTextField.text!, address: addressTextField.text!))
        payments.append(Payment(paymentMethod: "credit-card", number: cardTextField.text!, expMonth: expMonthTextField.text!, expYear: expYearTextField.text!, code: codeTextField.text!))

        getCheckout(items: items, recipient: recipients, shipping: shippings)
        getTransaction(payment: payments)
    }

    let cityPickerData = ["Taipei", "Taichung", "Tainan"]
    let titlePickerData = ["mister", "miss"]
    let expMonthPickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let expYearPickerData = ["2017", "2018", "2019", "2020", "2021", "2022"]

    var productIDFromSegue = ""
    var productNameFromSegue = ""
    var productPriceFromSegue = 0.0

    var items = [CheckoutItems]()

    var recipients = [Recipient]()

    var shippings = [Shipping]()

    var payments = [Payment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        var colors = [UIColor]()
        colors.append(UIColor(red: 3/255, green: 63/255, blue: 122/255, alpha: 1))
        colors.append(UIColor(red: 4/255, green: 107/255, blue: 149/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Georgia-Bold", size: 18)!]
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 53/255.0, green: 184/255.0, blue: 208/255.0, alpha: 0.85).cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2

        backItem.target = self
        backItem.action = #selector(backAction)

        shippingCityBottomView.layer.borderColor = UIColor(red: 82/255.0, green: 66/255.0, blue: 64/255.0, alpha: 1).cgColor
        shippingCityBottomView.layer.borderWidth = 0.5
        shippingCityBottomView.layer.backgroundColor = UIColor.white.cgColor

        recipientTitleBottomView.layer.borderColor = UIColor(red: 82/255.0, green: 66/255.0, blue: 64/255.0, alpha: 1).cgColor
        recipientTitleBottomView.layer.borderWidth = 0.5
        recipientTitleBottomView.layer.backgroundColor = UIColor.white.cgColor

        paymentExpMonthBottomView.layer.borderColor = UIColor(red: 82/255.0, green: 66/255.0, blue: 64/255.0, alpha: 1).cgColor
        paymentExpMonthBottomView.layer.borderWidth = 0.5
        paymentExpMonthBottomView.layer.backgroundColor = UIColor.white.cgColor

        paymentExpYearBottomView.layer.borderColor = UIColor(red: 82/255.0, green: 66/255.0, blue: 64/255.0, alpha: 1).cgColor
        paymentExpYearBottomView.layer.borderWidth = 0.5
        paymentExpYearBottomView.layer.backgroundColor = UIColor.white.cgColor

        //self.stepper.transform = CGAffineTransform(scaleX: 0.69, y: 0.69)

        cityTextField.font = UIFont(name: ".SFUIText", size: 16)
        postalCodeTextField.font = UIFont(name: ".SFUIText", size: 16)
        addressTextField.font = UIFont(name: ".SFUIText", size: 16)
        firstNameTextField.font = UIFont(name: ".SFUIText", size: 16)
        lastNameTextField.font = UIFont(name: ".SFUIText", size: 16)
        titleTextField.font = UIFont(name: ".SFUIText", size: 16)
        phoneTextField.font = UIFont(name: ".SFUIText", size: 16)
        cardTextField.font = UIFont(name: ".SFUIText", size: 16)
        expMonthTextField.font = UIFont(name: ".SFUIText", size: 16)
        expYearTextField.font = UIFont(name: ".SFUIText", size: 16)
        codeTextField.font = UIFont(name: ".SFUIText", size: 16)
        productName.text = productNameFromSegue
        productPrice.text = "$ \(productPriceFromSegue)"
        productImageView.downloadedFrom(link: "http://52.198.40.72/patissier/products/\(productIDFromSegue)/preview.jpg", contentMode: .scaleAspectFit)
        purchaseButton.layer.cornerRadius = 2
        purchaseButton.layer.shadowRadius = 2
        purchaseButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        purchaseButton.layer.shadowOpacity = 1
        purchaseButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)

        bottomView.layer.shadowOpacity = 1
        bottomView.layer.shadowColor = UIColor(red: 255/255.0, green: 174/255.0, blue: 171/255.0, alpha: 0.85).cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -2)

        cityTextField.inputView = cityPicker
        titleTextField.inputView = titlePicker
        expMonthTextField.inputView = expMonthPicker
        expYearTextField.inputView = expYearPicker
        cityPicker.delegate = self
        titlePicker.delegate = self
        expMonthPicker.delegate = self
        expYearPicker.delegate = self
    }

    func backAction() {
        dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case cityPicker: return cityPickerData.count
        case titlePicker: return titlePickerData.count
        case expMonthPicker: return expMonthPickerData.count
        case expYearPicker: return expYearPickerData.count
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        switch pickerView {

        case cityPicker:
            cityTextField.text = cityPickerData[row]
            return cityPickerData[row]
        case titlePicker:
            titleTextField.text = titlePickerData[row]
            return titlePickerData[row]
        case expMonthPicker:
            expMonthTextField.text = expMonthPickerData[row]
            return expMonthPickerData[row]
        case expYearPicker:
            expYearTextField.text = expYearPickerData[row]
            return expYearPickerData[row]
        default:
            return ""
        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case cityPicker:

            return cityTextField.text = cityPickerData[row]
        case titlePicker:

            return titleTextField.text = titlePickerData[row]
        case expMonthPicker:

            return expMonthTextField.text = expMonthPickerData[row]
        case expYearPicker:
            return expYearTextField.text = expYearPickerData[row]
        default:
            return
        }

    }

//    private func formattedNumber(number: String) -> String {
//        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
//        var mask = "XXXX - XXX - XXX"
//
//        var result = ""
//        var index = cleanPhoneNumber.startIndex
//        for ch in mask.characters {
//            if index == cleanPhoneNumber.endIndex {
//                break
//            }
//            if ch == "X" {
//                result.append(cleanPhoneNumber[index])
//                index = cleanPhoneNumber.index(after: index)
//            } else {
//                result.append(ch)
//            }
//        }
//        return result
//    }

}
