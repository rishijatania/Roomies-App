//
//  GroupActionViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/20/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class GroupActionViewController: UIViewController, UITextFieldDelegate {
    
    //    static var appdel =  UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var switchlbl: UILabel!
    @IBOutlet weak var grpNameLbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var grpDesc: UITextField!
    @IBOutlet weak var groupId: UITextField!
    @IBOutlet weak var `switch`: UISwitch!
    @IBAction func `switch`(_ sender: UISwitch) {
        if(sender.isOn){
            switchlbl.text="Yes"
            grpNameLbl.isHidden = true
            grpDesc.isHidden=true
            btn.setTitle("Join", for: .normal)
            firstLbl.text="Group Id"
            groupId.keyboardType = .numberPad
            groupId.text = ""
        }
        else{
            switchlbl.text="No"
            grpNameLbl.isHidden = false
            grpDesc.isHidden=false
            btn.setTitle("Create", for: .normal)
            firstLbl.text="Group Name"
            groupId.keyboardType = .default
            groupId.text = ""
        }
        btn.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);
        firstLbl.text="Group Id"
        switchlbl.text="Yes"
        grpNameLbl.isHidden = true
        grpDesc.isHidden=true
        btn.setTitle("Join", for: .normal)
        initializeTextFields()
        groupId.keyboardType = .numberPad
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Singleton.shared.userGroupInfo?.groupId != nil {
            self.performSegue(withIdentifier: "secondStorysg", sender: self)
        }
    }
    
    @IBAction func grpAction(_ sender: Any) {
        
        if `switch`.isOn {
            guard let groupID = groupId.text, !groupID.isEmptyOrWhitespace() && groupID.isNumeric() else {
                showAlert(title: "Enter valid Group ID")
                return
            }
            perfromGroupJoin(groupID: Int(groupID) ?? 0)
        }
        else {
            guard let grpName = groupId.text, !grpName.isEmptyOrWhitespace() else {
                showAlert(title: "Enter valid Group Name")
                return
            }
            guard let grpDescription = grpDesc.text, !grpDescription.isEmptyOrWhitespace() else {
                showAlert(title: "Enter valid Group Description")
                return
            }
            perfromGroupCreate(name: grpName, desc: grpDescription)
        }
    }
    
    func perfromGroupCreate(name:String,desc:String){
        CreateGroupRequest(groupName: name, groupDescription: desc)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.clearFields()
                    self.showAlertPerFromAppJourney(title: "Group with Name \(name) Created successfully")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title: errorResponse?.message ?? "Bad Request\nPlease try again!")
            })
        
    }
    
    func perfromGroupJoin(groupID:Int){
        JoinGroupRequest(groupId: groupID)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.clearFields()
                    self.showAlertPerFromAppJourney(title: "User Joined In Group with ID \(groupID) successfully")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Bad Request\nPlease try again!")
            })
        
    }
    
    func getGroupInfo () {
        GroupInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    self.clearFields()
                    Singleton.shared.userGroupInfo=successResponse
                    self.performSegue(withIdentifier: "secondStorysg", sender: self)
            },
                onFailure: { (errorResponse, error) in
                    Singleton.shared.userGroupInfo=nil
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Bad Request\nPlease try Login In again!")
                    
            })
    }
    
    func showAlertPerFromAppJourney(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default){
            UIAlertAction in
            self.getGroupInfo()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func clearFields() {
        grpDesc.text=""
        groupId.text=""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func initializeTextFields() {
        grpDesc.delegate=self
        groupId.delegate=self
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
        case _ as TabBarViewController:
            
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
            let appscene = TabBarViewController.instantiateFromAppStoryBoard(appStoryBoard: .App)
            appDelegate.window?.rootViewController = appscene
            appDelegate.window?.makeKeyAndVisible()
        default:
            print("")
        }
        
    }
    
    
}
