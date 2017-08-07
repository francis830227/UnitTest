//
//  PostViewController.swift
//  Fire Base Demo
//
//  Created by Francis Tseng on 2017/7/21.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PostViewController: UIViewController, UITextViewDelegate {

   
    @IBOutlet weak var textView: UITextView!
    
    var ref: DatabaseReference?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        ref?.child("user").child("Posts").child("Text").childByAutoId().setValue(textView.text)
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "write sth!" {
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "write sth!"
        }
        textView.resignFirstResponder()
    }
}
