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
import AssetsPickerViewController
import Photos

class GalleryViewController: UIViewController, AssetsPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {

    }
    
    let baseURL = "http://django-env.mzkdgeh5tz.us-east-1.elasticbeanstalk.com:80/api/demo64/"
    let test = "http://10.108.93.47:8000/api/demo64/"
    var access = ""
    var rekognize: JSON?
    let imagePicker = UIImagePickerController()
    let picker = AssetsPickerViewController()
    @IBOutlet weak var selectedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //imagePicker.delegate = self
        picker.pickerDelegate = self
        
    }
    
    @IBAction func loadImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        present(picker, animated: true, completion: nil)
        //present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage.image = image
        picker.dismiss(animated: true, completion: nil) }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func rekognize(_ sender: Any) {
        let imageData = selectedImage.image?.jpegData(compressionQuality: 1.0)
        let imageSting = imageData!.base64EncodedString()
        let parameter = ["base_64":imageSting]
        //print(parameter)
        let header : HTTPHeaders = ["Authorization":"Bearer \(access)"]
        Alamofire.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{
            response in
            if response.result.isSuccess{
                self.rekognize  = JSON(response.result.value!)
                self.performSegue(withIdentifier: "galleryToPreview", sender: self)
            } else{
                print("Error \(String(describing: response.result.error))")
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "galleryToPreview"{
            let nav = segue.destination as! UINavigationController
            let destination = nav.viewControllers.first as! previewTableViewController
            destination.photo = selectedImage.image
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
