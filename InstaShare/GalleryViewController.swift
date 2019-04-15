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
    
    var imgArray = [UIImage]()
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        i = 0
        self.imgArray = [UIImage]()
        let imgManager = PHImageManager.default()
        let request = PHImageRequestOptions()
        request.isSynchronous = true
        request.deliveryMode = .highQualityFormat
        for asset in assets{
            imgManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: request, resultHandler: {
                image, error in
                self.imgArray.append(image!)
            })
        }
        selectedImage.image = imgArray[0]
        current.text = "1"
        total.text = "\(imgArray.count)"
        if i == imgArray.count - 1{
            nextButton.isEnabled = false
        }
        else{
            nextButton.isEnabled = true
        }
        if i == 0{
            prevButton.isEnabled = false
        }
        else{
            prevButton.isEnabled = true
        }
    }
    
    let baseURL = "http://django-env.mzkdgeh5tz.us-east-1.elasticbeanstalk.com:80/api/singlephotoMobile/"
    let test = "http://10.108.93.47:8000/api/singlephotoMobile/"
    var access = ""
    var rekognize: JSON?
    let imagePicker = UIImagePickerController()
    let picker = AssetsPickerViewController()
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var total: UILabel!
    var i = 0
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBAction func nextAction(_ sender: Any) {
        i=i+1
        selectedImage.image = imgArray[i]
        current.text = "\(i+1)"
        prevButton.isEnabled = true
        if i == imgArray.count - 1{
            nextButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var prevButton: UIButton!
    @IBAction func prevAction(_ sender: Any) {
        i=i-1
        selectedImage.image = imgArray[i]
        current.text = "\(i+1)"
        nextButton.isEnabled = true
        if i == 0{
            prevButton.isEnabled = false
        }
    }
    @IBOutlet weak var selectedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prevButton.isEnabled = false
        nextButton.isEnabled = false
        current.text = "0"
        total.text = "0"
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
        //let imageData = selectedImage.image?.jpegData(compressionQuality: 1.0)
        //let imageSting = imageData!.base64EncodedString()
        //let parameter = ["base_64":imageSting]
        var parameter = ["group_photos" : [String]()]
        for image in imgArray{
            let imageData = image.jpegData(compressionQuality: 1.0)
            let imageSting = imageData!.base64EncodedString()
            parameter["group_photos"]!.append(imageSting)
        }
        //print(parameter)
        let header : HTTPHeaders = ["Authorization":"Bearer \(access)"]
        Alamofire.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{
            response in
            if response.result.isSuccess{
                print(response.result.value!)
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
            destination.access = access
            
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
