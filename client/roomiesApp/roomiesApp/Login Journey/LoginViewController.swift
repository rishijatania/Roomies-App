//
//  LoginViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/20/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        //perform login
        
        guard let uName = userNameTF.text, !uName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter valid UserName")
            return
        }
        guard let password = passwordTF.text, !password.isEmptyOrWhitespace() else {
            showAlert(title: "Enter valid Password")
            return
        }
        performLogin(username:uName,password:password)
    }
    
    func clearFields() {
        userNameTF.text=""
        passwordTF.text=""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func initializeTextFields() {
        userNameTF.delegate=self
        passwordTF.delegate=self
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc:UIViewController = segue.destination
        switch vc {
            //                  case let td as TrainViewController:
            //                      td.selectedTrain = self.selectedTrain
            //                  case let ct as CreateTrainViewController:
        //                      ct.isCreate = true
        default:
            print("")
        }
    }
    
    func performLogin (username:String,password:String){
        SigninRequest(username: username, password: password)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.clearFields()
                    Singleton.shared.userCreds=successResponse
                    self.showAlertSigninAction(title:"Login Successful\n Welcome \(username)!")
                    //                    self.showAlert(title:"Login Successful\n Welcome \(username)!")
            },
                onFailure: { (errorResponse, error) in
                    self.clearFields()
                    Singleton.shared.userCreds=nil
                    self.showAlert(title:errorResponse?.message ?? "Invalid Credentials\nPlease try again!")
            })
    }
    
    func getGroupInfo () {
        GroupInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    self.clearFields()
                    Singleton.shared.userGroupInfo=successResponse
                    self.performSegue(withIdentifier: "logingrpsg", sender: self)
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    Singleton.shared.userGroupInfo=nil
                    if errorResponse?.status == 404 && errorResponse?.message == "User not part of any group!"{
                        self.performSegue(withIdentifier: "logingrpsg", sender: self)
                    }
                    else {
                        Singleton.shared.userGroupInfo=nil
                        self.showAlert(title:errorResponse?.message ?? "Bad Request\nPlease try Login In again!")
                    }
            })
    }
}
