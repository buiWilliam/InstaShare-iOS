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

class PhotoViewController: UIViewController {
    
    let baseURL = "http://192.168.56.1:8000/api//"

    var takenPhoto:UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
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
        //let base64String = imageData!.base64EncodedString(options: .lineLength64Characters)
        sendImage(image: imageData!)
        let alert = UIAlertController(title: "Saved", message: "Image sent for recognition", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func sendImage(image: Data){
        Alamofire.upload(image, to: baseURL)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
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
