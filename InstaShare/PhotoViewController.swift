//
//  PhotoViewController.swift
//  InstaShare
//
//  Created by William Bui on 3/13/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MessageUI
import Contacts

class PhotoViewController: UIViewController,MFMessageComposeViewControllerDelegate {
    
    let baseURL = "http://django-env.mzkdgeh5tz.us-east-1.elasticbeanstalk.com:80/api/singlephotoMobile/"
    let test = "http://10.108.93.47:8000/api/singlephotoMobile/"
    var access = ""
    var takenPhoto:UIImage?
    @IBOutlet weak var imageView: UIImageView!
    var rekognize: JSON?
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let availableImage = takenPhoto{
            imageView.image=availableImage
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveImage(_ sender: Any) {
        let imageData = imageView.image!.jpegData(compressionQuality: 1.0)
        let compressedimage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedimage!, nil, nil, nil)
        sendImage(image: imageData!)
    }
    
    func sendImage(image: Data){
        let imageSting = image.base64EncodedString()
        let parameter = ["base_64":imageSting]
        //print(parameter)
        let header : HTTPHeaders = ["Authorization":"Bearer \(access)"]
        Alamofire.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{
            response in
            if response.result.isSuccess{
                self.rekognize  = JSON(response.result.value!)
                self.performSegue(withIdentifier: "cameraToPreview", sender: nil)
            } else{
                print("Error \(String(describing: response.result.error))")
            }
            
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func addContact(_ sender: Any) {
        let newContact = CNMutableContact()
        var firstName = UITextField()
        var lastName = UITextField()
        var phoneNumber = UITextField()
        let alert = UIAlertController(title: "Add New Contact", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Contact", style: .default) { (action) in
            newContact.givenName = firstName.text!
            newContact.familyName = lastName.text!
            newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phoneNumber.text!))]
            newContact.imageData = self.takenPhoto?.jpegData(compressionQuality: 1)
            do {
                let newContactRequest = CNSaveRequest()
                newContactRequest.add(newContact, toContainerWithIdentifier: nil)
                try CNContactStore().execute(newContactRequest)
                // ... if control flow gets here, save operation succeed.
            } catch {
                // ... deal with error
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertFirstName) in
            alertFirstName.placeholder = "First Name"
            firstName = alertFirstName
        }
        alert.addTextField { (alertLastName) in
            alertLastName.placeholder = "Last Name"
            lastName = alertLastName
        }
        alert.addTextField { (alertPhoneNumber) in
            alertPhoneNumber.placeholder = "Phone Number"
            phoneNumber = alertPhoneNumber
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cameraToPreview"{
            let nav = segue.destination as! UINavigationController
            let destination = nav.viewControllers.first as! previewTableViewController
            destination.photo = imageView.image
            destination.rekognize = rekognize
        }
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
