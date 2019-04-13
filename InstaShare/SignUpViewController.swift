//
//  SignUpViewController.swift
//  InstaShare
//
//  Created by William Bui on 3/16/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var phone_number: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    
    let baseURL = "http://django-env.mzkdgeh5tz.us-east-1.elasticbeanstalk.com:80/api/register/"
    let test = "http://10.108.93.47:8000/api/register/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.username.inputAccessoryView = toolbar
        self.password.inputAccessoryView = toolbar
        self.passwordConfirm.inputAccessoryView = toolbar
        self.eMail.inputAccessoryView = toolbar
        self.phone_number.inputAccessoryView = toolbar
        self.firstName.inputAccessoryView = toolbar
        self.lastName.inputAccessoryView = toolbar
        // Do any additional setup after loading the view.
        observeKeyboardNotification()
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func submitButton(_ sender: Any){
        if (username.text == "" || password.text == "" || passwordConfirm.text == "" || eMail.text == "" || phone_number.text == "" || firstName.text == "" || lastName.text == ""){
            print("Required text field is blank")
        }
        else if password.text != passwordConfirm.text{
            print("Password does not match")
        }
        else{
            let parameter = submit()
            print(parameter)
            Alamofire.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON{
                response in
                if response.result.isSuccess{
                    let signup  = JSON(response.result.value!)
                    print(signup)
                    if signup["id"] != "" {
                        self.performSegue(withIdentifier: "signUpToLogIn", sender: self)
                    }
                } else{
                    print("Error \(String(describing: response.result.error))")
                }
            }
        }
    }
    
    
    
    func submit()->[String:String]{
        let parameter = ["username": self.username.text!, "password": self.password.text!, "email": eMail.text!, "phone_number": self.phone_number.text!, "first_name":firstName.text!,"last_name":lastName.text!]
        return parameter
    }
    
    
    func observeKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x:0,y:(self.view.frame.height)/(-4),width: self.view.frame.width,height: self.view.frame.height)
        }, completion: nil)
    }
    @objc func keyboardHide(){
        print("Keyboard Shown")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width,height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
