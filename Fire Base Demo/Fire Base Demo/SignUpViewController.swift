//
//  SignUpViewController.swift
//  Fire Base Demo
//
//  Created by Francis Tseng on 2017/7/20.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var alertText: UILabel!
    
    var ref: DatabaseReference?
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        if firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            alertText.isHidden = false
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeNVC")
                    self.present(vc!, animated: true, completion: nil)
                    
                    self.ref?.childByAutoId().child("Posts").child("Name").setValue("\(self.firstNameTextField.text ?? "") \(self.lastNameTextField.text ?? "")")
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

    }


}
