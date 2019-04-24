//
//  ContactTableViewController.swift
//  InstaShare
//
//  Created by William Bui on 3/13/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit
import Contacts
import Alamofire
import SwiftyJSON

class ContactTableViewController: UITableViewController {
    
    let cellID = "cellID"
    let baseURL = "http://django-env.mzkdgeh5tz.us-east-1.elasticbeanstalk.com:80/api/uploadContactMobile/"
    let test = "http://10.108.94.186:8000/api/uploadContactMobile/"
    var access = ""
    var username = ""
    var count = 0
    var action: UIAlertAction?
    let storage = UserDefaults.standard
    var id : [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("access token: \(access)")
        if storage.dictionary(forKey: username)?.isEmpty == false{
            id = storage.dictionary(forKey: username) as! [String:String]
        }
        fetchContact()
        uploadContact()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    struct Info: Codable {
        var identifier: String
        var referencePic: Data?
        var name: String?
        var phoneNumber: String?
        var firstName: String?
        var lastName: String?
    }
    
    var notReady = [Info]()
    var ready = [Info]()
    
    private func fetchContact() {
        print("Fetching contact")
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts){ (granted, err) in
            if let err = err {
                print("Failed to request",err)
                return
            }
            
            if granted {
                print("Access granted")
                
                let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactImageDataKey,CNContactImageDataAvailableKey,CNContactIdentifierKey]
                
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do{
                    
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWanttoStopEnumerating) in
                        if contact.imageDataAvailable{
                            self.ready.append(Info(identifier: contact.identifier, referencePic: contact.imageData, name: contact.givenName + " " + contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue,firstName: contact.givenName, lastName: contact.familyName))
                        } else{
                            self.notReady.append(Info(identifier: contact.identifier, referencePic: nil, name: contact.givenName + " " + contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue,firstName: contact.givenName, lastName: contact.familyName))
                        }
                        
                    })
                    
                } catch let err{
                    print("Failure in trying",err)
                }
                
            } else {
                print("Access denied")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray
        if section == 0{
            label.text = "Ready for Rekognition"
        } else{
            label.text = "Not Ready"
        }
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return ready.count
        }
        return notReady.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let name = indexPath.section == 0 ? self.ready[indexPath.row].name : self.notReady[indexPath.row].name
        var phonenumber = ""
        if (indexPath.section == 0 ? self.ready[indexPath.row].phoneNumber : self.notReady[indexPath.row].phoneNumber) != nil{
            phonenumber = indexPath.section == 0 ? self.ready[indexPath.row].phoneNumber! : self.notReady[indexPath.row].phoneNumber!
        }
        cell.textLabel?.text = name! + " " + phonenumber
        if (indexPath.section == 0 ? self.ready[indexPath.row].referencePic : self.notReady[indexPath.row].referencePic) != nil{
            let image = indexPath.section == 0 ? self.ready[indexPath.row].referencePic : self.notReady[indexPath.row].referencePic
            cell.imageView?.image = UIImage(data: image!)
        }
        else{
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func uploadContact(){
        let alert = UIAlertController(title: "Uploading contacts", message: "Please wait...", preferredStyle: .alert)
        action = UIAlertAction(title: "Done", style: .default) { (action) in
            print("Done")
        }
        action!.isEnabled = false
        alert.addAction(action!)
        present(alert, animated: true, completion: nil)
        let header : HTTPHeaders = ["Authorization":"Bearer \(access)"]
        count = ready.count
        for info in ready{
            print(info.name!)
            let image = UIImage(data: info.referencePic!)
            let imageData = image!.jpegData(compressionQuality: 1.0)
            let imageString = imageData?.base64EncodedString()
            print(info.phoneNumber!)
            let phoneNumber = trim(phonenumber: info.phoneNumber!)
            let parameters = ["name":info.name!,"phone_number":phoneNumber,"base_64":imageString!]
            
            if id[info.identifier]==nil{
                Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON{
                    response in
                    if response.result.isSuccess{
                        let contact = JSON(response.result.value!)
                        if contact["id"].stringValue != ""{
                            let idPair = [info.identifier:contact["id"].stringValue]
                            self.id.merge(idPair, uniquingKeysWith: {(_,new) in new})
                            self.storage.set(self.id, forKey: self.username)
                        }
                        self.checkIfRequestFinished()
                        print(contact)
                    } else{
                        print("Error \(String(describing: response.result.error))")
                    }
                }
            }
            else{
                print("Making a put request with ID: \(id[info.identifier]!)")
                let putUrl = "\(baseURL)\(id[info.identifier]!)/"
                print(putUrl)
                Alamofire.request(putUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON{
                    response in
                    if response.result.isSuccess {
                        let contact = JSON(response.result.value!)
                        self.checkIfRequestFinished()
                        print(contact)
                        
                    }
                }
            }
        }
    }
    
    func trim(phonenumber:String)->String{
        let digit = phonenumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return digit
    }
    
    func checkIfRequestFinished(){
        print(count)
        count = count - 1
        if count == 0 {
            action?.isEnabled = true
        }
    }
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

