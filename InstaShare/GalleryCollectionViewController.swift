//
//  GalleryCollectionViewController.swift
//  InstaShare
//
//  Created by William Bui on 4/12/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MessageUI
import AssetsPickerViewController
import Photos

class GalleryCollectionViewCell:UICollectionViewCell{
    @IBOutlet weak var imgView: UIImageView!
}

class GalleryCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,AssetsPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    let baseURL = "http://django-env.mzkdgeh5tz.us-east-1.elasticbeanstalk.com:80/api/demo64/"
    let test = "http://10.108.93.47:8000/api/demo64/"
    var access = ""
    var rekognize: JSON?
    let imagePicker = UIImagePickerController()
    let picker = AssetsPickerViewController()
    

    var imgArray = [UIImage]()
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        let imgManager = PHImageManager.default()
        let request = PHImageRequestOptions()
        request.isSynchronous = true
        request.deliveryMode = .highQualityFormat
        for asset in assets{
            imgManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: request, resultHandler: {
                image, error in
                self.imgArray.append(image!)
            })
        }
        print("imgArrayCount: \(imgArray.count)")
        self.collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

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
        //selectedImage.image = image
        picker.dismiss(animated: true, completion: nil) }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func rekognize(_ sender: Any) {
        //let imageData = selectedImage.image?.jpegData(compressionQuality: 1.0)
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
            //destination.photo = selectedImage.image
            destination.rekognize = rekognize
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(imgArray.count)
        return imgArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
    
        // Configure the cell
        cell.imgView.image = imgArray[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width)
    }
    
}
