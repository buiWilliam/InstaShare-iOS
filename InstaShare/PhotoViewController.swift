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

class PhotoViewController: UIViewController,MFMessageComposeViewControllerDelegate {
    
    let baseURL = "http://10.110.32.66:8000/api/demo64/"
    let test = "http://10.108.93.47:8000/api/demo64/"
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
        Alamofire.request(test, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{
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
