//
//  SignUpViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/20/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit
import Foundation
class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phnNo: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        initializeTextFields()
        super.viewDidLoad()
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let uName = userName.text, !uName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct UserName")
            return
        }
        guard let em = email.text, !em.isEmptyOrWhitespace() && em.isValidEmail() else {
            showAlert(title: "Enter valid Email")
            return
        }
        
        guard let fName = firstName.text, !fName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct First Name")
            return
        }
        
        guard let lName = lastName.text, !lName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct Last Name")
            return
        }
        guard let phone = phnNo.text, phone.isValidPhone() else {
            showAlert(title: "Enter correct Phone No")
            return
        }
        guard let pass = password.text, !pass.isEmptyOrWhitespace() else {
            showAlert(title: "Enter valid Password")
            return
        }
        
        //call api
        performSignUp(username: uName, email: em, password: pass, role:["user"], firstName: fName, lastName: lName, phoneNo: Int(phone)!)
    }
    
    func clearFields() {
        userName.text=""
        email.text=""
        firstName.text=""
        lastName.text=""
        phnNo.text=""
        password.text=""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func initializeTextFields() {
        userName.delegate=self
        email.delegate=self
        firstName.delegate=self
        lastName.delegate=self
        phnNo.delegate=self
        password.delegate=self
    }
    
    func showAlert(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showAlertSigninAction(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) {
            UIAlertAction in
            self.getGroupInfo()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func performSignUp (username: String, email: String, password: String, role: [String], firstName: String, lastName: String, phoneNo: Int){
        SignupRequest(username: username, email: email, password: password, role: role, firstName: firstName, lastName: lastName, phoneNo: phoneNo)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.performLogin(username: username, password: password)
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Bad Request\nPlease try again!")
            })
    }
    
    private func performLogin (username:String,password:String) {
        SigninRequest(username: username, password: password)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.clearFields()
                    Singleton.shared.userCreds=successResponse
                    self.showAlertSigninAction(title:"SignUp Successful\n Welcome \(username)!")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    Singleton.shared.userCreds=nil
                    self.showAlert(title:errorResponse?.message ?? "Bad Request\nPlease try Login In again!")
            })
    }
    
    func getGroupInfo () {
        GroupInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    self.clearFields()
                    Singleton.shared.userGroupInfo=successResponse
                    self.performSegue(withIdentifier: "signupgrpsg", sender: self)
            },
                onFailure: { (errorResponse, error) in
                    Singleton.shared.userGroupInfo=nil
                    if errorResponse?.status == 404 && errorResponse?.message == "User not part of any group!"{
                        self.performSegue(withIdentifier: "signupgrpsg", sender: self)
                    }
                    else {
                        print(errorResponse?.message ?? "")
                        self.showAlert(title:errorResponse?.message ?? "Bad Request\nPlease try Login In again!")
                    }
            })
    }
}
