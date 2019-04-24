//
//  previewTableViewController.swift
//  InstaShare
//
//  Created by William Bui on 4/3/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI

class previewTableCell: UITableViewCell{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone_number: UILabel!
    @IBOutlet weak var checkMark: UIButton!
    @IBAction func selectCheck(_ sender: Any) {
        if checkMark.isSelected{
            checkMark.isSelected = false
        } else{ checkMark.isSelected = true
        }
    }
}



class previewTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
    let cellID = "cellID"
    var access = ""
    var photo = [UIImage]()
    var username = ""
    var rekognize: JSON?
    struct contact{
        var name: String
        var phone_number: String
    }
    var list = [contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = [contact]()
        for (_,subJson):(String, JSON) in rekognize! {
            let name = subJson["name"].stringValue
            let phone_number = subJson["phone_number"].stringValue
            self.list.append(contact(name: name, phone_number: phone_number))
        }
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(list.count)
        return list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! previewTableCell
        
        let name = self.list[indexPath.row].name
        var phonenumber = ""
        phonenumber = self.list[indexPath.row].phone_number
        
        cell.name?.text = name
        cell.phone_number?.text = phonenumber
        
        print(cell.name!.text!)
        print(cell.phone_number!.text!)
        
        return cell
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result)
        {
        case MessageComposeResult.cancelled:
            NSLog("Mail cancelled");
            break;
        case MessageComposeResult.sent:
            NSLog("Mail sent");
            break;
        case MessageComposeResult.failed:
            NSLog("Mail sent failure");
            break;
        default:
            break;
        }
        
        // Close the Mail Interface
        controller.dismiss(animated: true, completion: nil)
        if result == MessageComposeResult.sent{
            self.performSegue(withIdentifier: "previewToHome", sender: self)
        }
    }
    
    
    
    @IBAction func composeMessage(_ sender: Any) {
        displayMessageInterface()
    }
    
    @IBAction func addToList(_ sender: Any) {
        
    }
    
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = []
        var cells = [previewTableCell]()
        for section in 0 ..< tableView.numberOfSections {
            let rowCount = tableView.numberOfRows(inSection: section)
            for row in 0 ..< rowCount {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! previewTableCell
                cells.append(cell)
            }
        }
        for cell in cells{
            if cell.checkMark.isSelected != true{
                print("phone number: \(cell.phone_number.text!)")
                composeVC.recipients?.append(cell.phone_number.text!)
            }
        }
        composeVC.body = "Sent from InstaShare"
        var i = 0
        for image in photo{
            composeVC.addAttachmentData(image.jpegData(compressionQuality: 1.0)!, typeIdentifier: "public.data", filename: "image\(i).jpeg")
            i = i + 1
        }
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewToHome"{
            let destination = segue.destination as! ViewController
            destination.access = access
            destination.username = username
        }
    }
    
    @IBAction func goHome(_ sender: Any) {
        self.performSegue(withIdentifier: "previewToHome", sender: self)
    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
