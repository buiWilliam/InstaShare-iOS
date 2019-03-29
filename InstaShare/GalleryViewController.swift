//
//  GalleryViewController.swift
//  InstaShare
//
//  Created by William Bui on 3/27/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MessageUI

class GalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    
    let baseURL = "http://10.110.41.120:8000/api/demo64/"
    var access = ""
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var selectedImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    
    @IBAction func loadImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage.image = image
        picker.dismiss(animated: true, completion: nil) }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func rekognize(_ sender: Any) {
        /*let imageData = selectedImage.image?.jpegData(compressionQuality: 1.0)
        let imageSting = imageData!.base64EncodedString()
        let parameter = ["base_64":imageSting]
        print(parameter)
        let header : HTTPHeaders = ["Authorization":"Bearer \(access)"]
        Alamofire.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{
            response in
            if response.result.isSuccess{
                let rekognize  = JSON(response.result.value!)
                print(rekognize)
                let alert = UIAlertController(title: "Found", message: "\(rekognize["first_name"]) \(rekognize["last_name"])", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            } else{
                print("Error \(String(describing: response.result.error))")
            }
            
        }*/
        self.performSegue(withIdentifier: "galleryToPreview", sender: self)
    }
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = ["2159419203","2676401186"]
        composeVC.addAttachmentData((selectedImage.image!.jpegData(compressionQuality: 1.0))!, typeIdentifier: "public.data", filename: "image.jpeg")
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "galleryToPreview"{
            let destination = segue.destination as! previewViewController
            destination.photo = selectedImage.image
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
