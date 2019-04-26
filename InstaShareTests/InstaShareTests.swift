//
//  InstaShareTests.swift
//  InstaShareTests
//
//  Created by Ananth Prayaga on 4/24/19.
//  Copyright © 2019 William Bui. All rights reserved.
//

import XCTest

@testable import InstaShare
import Alamofire
import SwiftyJSON
import Contacts

class InstaShareTests: XCTestCase {
    var testLogin: LoginViewController!
    var testSignup: SignUpViewController!
    var testContact: ContactTableViewController!
    var username: String!
    var password: String!
    var accessToken: String!
    var parameter: [String:String]!
    var url: String!
    var header: [String:String]!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testLogin = LoginViewController()
        testSignup = SignUpViewController()
        testContact = ContactTableViewController()
        username = "TestAcc2"
        password = "123"
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testSignup = nil
        testLogin = nil
    }

    func testSignupFunc() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        testSignup.eMail = UITextField()
        testSignup.eMail.text = "a@a.com"
        testSignup.firstName = UITextField()
        testSignup.firstName.text = "Kermit"
        testSignup.lastName = UITextField()
        testSignup.lastName.text = "Frog"
        testSignup.username = UITextField()
        testSignup.username.text = username
        testSignup.password = UITextField()
        testSignup.password.text = password
        testSignup.phone_number = UITextField()
        testSignup.phone_number.text = "1234567890"
        parameter = testSignup.submit()
        url = testSignup.baseURL
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            if response.result.isSuccess{
                let returned = JSON(response.result.value!)
                XCTAssert(returned["id"].stringValue != "", "SignUp Failed")
                print(returned["id"].stringValue)
            }
            else{
                print(response.result.error)
            }
        })
    }
    
    func testLoginFunc(){
        testLogin.username = UITextField()
        testLogin.password = UITextField()
        testLogin.username.text = username
        testLogin.password.text = password
        parameter = (["username":testLogin.username.text,"password":testLogin.password.text] as! [String : String])
        url = testLogin.baseURL
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                let returned = JSON(response.result.value!)
                XCTAssert(returned["access"].stringValue != "", "Login Failed")
                self.accessToken = returned["access"].stringValue
                self.header = ["Authorization":"Bearer \(self.accessToken!)"]
                print(self.header["Authorization"])
            }
            else{
                print(response.result.error)
            }
        }
    }
    
    func testContactfunc(){
        let fakeContact = CNMutableContact()
        fakeContact.givenName = "Place"
        fakeContact.familyName = "Holder"
        fakeContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: "2155555555"))]
        let placeHolderImage = UIImage(named: "source3_thumb")
        let imageData = placeHolderImage?.jpegData(compressionQuality: 1.0)
        let imageString = imageData?.base64EncodedString()
        let name = fakeContact.givenName + " " + fakeContact.familyName
        url = testContact.baseURL
        let phoneNumber = fakeContact.phoneNumbers.first?.value.stringValue
        parameter = (["name": name,"phone_number":phoneNumber,"base_64":imageString] as! [String : String])
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.isSuccess{
                let returned = JSON(response.result.value!)
                XCTAssert(returned["id"] != "", "Contact upload failed")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
