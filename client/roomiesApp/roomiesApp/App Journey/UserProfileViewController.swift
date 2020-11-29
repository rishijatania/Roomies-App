//
//  UserProfileViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/20/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var LastNameTF: UITextField!
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBAction func logout(_ sender: Any) {
        performSegue(withIdentifier: "logoutsg", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func update(_ sender: Any) {
        
        guard let fName = firstNameTF.text, !fName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct First Name")
            return
        }
        
        guard let lName = LastNameTF.text, !lName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct Last Name")
            return
        }
        guard let phone = phoneNoTF.text, phone.isValidPhone()  else {
            showAlert(title: "Enter correct Phone No")
            return
        }
        //call api
        updateUserInfo(userName.text!,email.text!,fName,lName,Int(phone)!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func initializeTextFields() {
        userName.delegate=self
        email.delegate=self
        firstNameTF.delegate=self
        LastNameTF.delegate=self
        phoneNoTF.delegate=self
        userName.text=Singleton.shared.userInfo?.username
        email.text=Singleton.shared.userInfo?.email
        firstNameTF.text=Singleton.shared.userInfo?.firstName
        LastNameTF.text=Singleton.shared.userInfo?.lastName
        phoneNoTF.text="\(Singleton.shared.userInfo?.phoneNo ?? 0)"
        
    }
    
    func showAlert(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc:UIViewController = segue.destination
        switch vc {
        case _ as LoginNavigationViewController:
            
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
            let appscene = LoginNavigationViewController.instantiateFromAppStoryBoard(appStoryBoard: .Main)
            //            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "myTabbarControllerID") as! TabBarViewController
            appDelegate.window?.rootViewController = appscene
            appDelegate.window?.makeKeyAndVisible()
            Singleton.shared.logout()
            //                  case let ct as CreateTrainViewController:
        //                      ct.isCreate = true
        default:
            print("")
        }
        
    }
    
    func getUserInfo () {
        UserInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    Singleton.shared.userInfo=successResponse
                    self.initializeTextFields()
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.initializeTextFields()
                    self.showAlert(title:errorResponse?.message ?? "Unable to get User Info\nPlease try again!")
            })
    }
    
    func updateUserInfo(_ username:String,_ email:String,_ fName:String, _ lName:String, _ phone:Int) {
        ProfileUpdateRequest(username:username,email:email,firstName:fName,lastName:lName,phoneNo:phone)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getUserInfo()
                    self.showAlert(title: "User Info Update Successfully")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.initializeTextFields()
                    self.showAlert(title:errorResponse?.message ?? "Unable to update User Info\nPlease try again!")
            })
    }
    
    
}
