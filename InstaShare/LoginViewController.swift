//
//  LoginViewController.swift
//  InstaShare
//
//  Created by William Bui on 3/16/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let baseURL = "http://10.110.41.120:8000/api/token/"
    var access: String = ""
    var refresh: String = ""
    
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
        // Do any additional setup after loading the view.
        observeKeyboardNotification()
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func observeKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(){
        print("Keyboard Shown")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x:0,y:-50,width: self.view.frame.width,height: self.view.frame.height)
        }, completion: nil)
    }
    @objc func keyboardHide(){
        print("Keyboard Shown")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width,height: self.view.frame.height)
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInToHome"{
            let destination = segue.destination as! ViewController
            destination.access = self.access
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        if username.text != "" && password.text != ""{
            let parameters = ["username":username.text!,"password":password.text!]
            print(parameters)
            Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON{
                response in
                if response.result.isSuccess{
                    let login : JSON = JSON(response.result.value!)
                    print(login)
                    self.saveToken(json: login)
                    if self.access != "" {
                        
                        self.performSegue(withIdentifier: "logInToHome", sender: self)
                    }
                    else{
                        print("No regristered account")
                    }
                } else{
                    print("Error \(String(describing: response.result.error))")
                }
            }
        } else{
            print("Required textfield empty.")
        }
    }
    
    func saveToken(json: JSON){
        self.access = json["access"].string ?? ""
        self.refresh = json["refresh"].string ?? ""
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
