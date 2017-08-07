//
//  LoginController.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/6/27.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginController: UIViewController {

    @IBOutlet weak var customLoginButton: UIButton!

    @IBAction func customLogin(_ sender: Any) {

    FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) {(_, error) in

        if error != nil {

            print("longinerror =\(String(describing: error))")

            return
        }

        self.fetchProfile()
        let json = ["access_token": "\(FBSDKAccessToken.current().tokenString!)"]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "http://52.198.40.72/patissier/api/v1/sign_in/facebook")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                //do anything here
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
            request.httpBody = jsonData
                if let downloadJSON = responseJSON as? [String: Any] {
                    if let downloadData = downloadJSON["data"] as? [String: Any] {
                        if let downloadToken = downloadData["token"] as? String {
                            UserDefaults.standard.setValue(downloadToken, forKey: "jwt")
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
            } catch(let error) {
                //Todo: errorhandling
                print(error)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "tabbar")
            self.present(controller, animated: true, completion: nil)
        }

        task.resume()//使用這行 request 才會送出去

        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundGradient: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 3/255.0, green: 63/255.0, blue: 122/255.0, alpha: 1).cgColor, UIColor(red: 4/255.0, green: 107/255.0, blue: 149/255.0, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y:0.5)
        backgroundGradient.layer.insertSublayer(gradient, at: 0)

        titleLabel.addCharactersSpacing(spacing: -1.2, text: "Pâtissier")
        titleLabel.layer.shadowRadius = 2

        customLoginButton.backgroundColor = UIColor(colorLiteralRed: 255/255.0, green: 53/255.0, blue: 71/255.0, alpha: 1)
        customLoginButton.layer.cornerRadius = 2
        customLoginButton.layer.shadowColor = UIColor(red: 3/255.0, green: 63/255.0, blue: 122/255.0, alpha: 1).cgColor
        customLoginButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        customLoginButton.layer.shadowRadius = 10
        customLoginButton.addTextSpacing(spacing: 0.2)
        customLoginButton.titleLabel?.font = UIFont(name: ".SFUIText-Semibold", size: 16)
        customLoginButton.titleLabel?.layer.shadowRadius = 2
        customLoginButton.titleLabel?.layer.shadowOpacity = 0.1
    }

    func fetchProfile() {
        print("******** fetch profile *******")

        let parameters = ["fields": "email, id, name"]

        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { _, result, error -> Void in

            if error != nil {
                print("longinerror =\(String(describing: error))")
            } else {

                if let resultNew = result as? [String:Any] {

                    guard let name = resultNew["name"] else { return }
                    print("Name : \(name)")

                    guard let id = resultNew["id"] else { return }
                    print("ID : \(id)")

                    guard let email = resultNew["email"] else { return }
                    print("email : \(email)")

                }
            }
        })
    }

}
