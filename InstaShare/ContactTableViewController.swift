//
//  ContactTableViewController.swift
//  InstaShare
//
//  Created by William Bui on 3/13/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import UIKit
import Contacts

class ContactTableViewController: UITableViewController {
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*navigationItem.title = "Contacts"
        let backButton = UIBarButtonItem.init(title: "Done", style: .plain, target: nil, action: #selector(goBack))
        navigationItem.rightBarButtonItem = backButton
        navigationController?.navigationBar.prefersLargeTitles = true
         */
        fetchContact()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    struct Info {
        var referencePic: Data?
        var name: String
        var phoneNumber: String?
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
                
                let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactImageDataKey,CNContactImageDataAvailableKey]
                
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do{
                    
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWanttoStopEnumerating) in
                        if contact.imageDataAvailable{
                            self.ready.append(Info(referencePic: contact.imageData, name: contact.givenName + " " + contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue))
                        } else{
                            self.notReady.append(Info(referencePic: nil, name: contact.givenName + " " + contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue))
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
        cell.textLabel?.text = name + " " + phonenumber
        if (indexPath.section == 0 ? self.ready[indexPath.row].referencePic : self.notReady[indexPath.row].referencePic) != nil{
            let image = indexPath.section == 0 ? self.ready[indexPath.row].referencePic : self.notReady[indexPath.row].referencePic
            cell.imageView?.image = UIImage(data: image!)
        }
        else{
            cell.imageView?.image = nil
        }
        return cell
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
