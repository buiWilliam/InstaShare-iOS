//
//  previewViewController.swift
//  InstaShare
//
//  Created by Ananth Prayaga on 3/29/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit

class previewViewController: UIViewController {
    var photo: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = photo

        // Do any additional setup after loading the view.
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
