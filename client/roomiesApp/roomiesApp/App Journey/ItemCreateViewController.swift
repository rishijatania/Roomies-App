//
//  ItemCreateViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class ItemCreateViewController: UIViewController,UserInchageViewControllerDelegate, UITextFieldDelegate, UsersListViewControllerDelegate {
    
    
    var isCreate:Bool?
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var completeByTF: UIDatePicker!
    @IBOutlet weak var boughtswitch: UISwitch!
    @IBOutlet weak var yeslbl: UILabel!
    @IBOutlet weak var sharedBylbl: UILabel!
    @IBOutlet weak var sharedByTF: UITextField!
    @IBOutlet weak var purchasedOblbl: UILabel!
    @IBOutlet weak var purchased: UIDatePicker!
    @IBOutlet weak var booughtbylbl: UILabel!
    @IBOutlet weak var boughtByTF: UITextField!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var createBTN: UIButton!
    var selectedItem:Item?
    var sharedByUsers:[String]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        completeByTF.backgroundColor = .white
        purchased.backgroundColor = .white
        // Do any additional setup after loading the view.
        viewWillAppear(true)
        if isCreate! {
            hideFields()
        }
        
    }
    
    @IBAction func complete(_ sender: UISwitch) {
        if sender.isOn {
            yeslbl.text = "Yes"
            showFields()
        }
        else{
            yeslbl.text = "No"
            hideFields()
        }
    }
    
    func hideFields() {
        sharedBylbl.isHidden = true
        sharedByTF.isHidden = true
        purchasedOblbl.isHidden = true
        purchased.isHidden = true
        booughtbylbl.isHidden = true
        boughtByTF.isHidden = true
        pricelbl.isHidden = true
        priceTF.isHidden = true
    }
    func showFields() {
        sharedBylbl.isHidden = false
        sharedByTF.isHidden = false
        purchasedOblbl.isHidden = false
        purchased.isHidden = false
        booughtbylbl.isHidden = false
        boughtByTF.isHidden = false
        pricelbl.isHidden = false
        priceTF.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isCreate! {
            createBTN.setTitle("Create", for: .normal)
            self.navigationItem.title="Create Item"
            boughtswitch.setOn(false, animated: true)
            boughtswitch.isUserInteractionEnabled = false
            hideFields()
        }
        else{
            let complete = selectedItem?.isTaskComplete == nil ? false :  selectedItem!.isTaskComplete
            if !complete {
                createBTN.setTitle("Update", for: .normal)
                self.navigationItem.title="Update Item"
                createBTN.isHidden=false
            }
            else {
                createBTN.isHidden=true
                boughtswitch.isUserInteractionEnabled = false
            }
            boughtswitch.setOn(true,animated: true)
            boughtswitch.isUserInteractionEnabled = false
            showFields()
            yeslbl.text = "Yes"
            itemNameTF.text = selectedItem?.itemName
            if nil != selectedItem{
                let isoDate = selectedItem?.completionDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from:isoDate!)!
                completeByTF.setDate(date, animated: true)
            }
            if nil != selectedItem?.purchasedOnDate {
                let isodate2 = selectedItem?.purchasedOnDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date2 = dateFormatter.date(from:isodate2!)!
                purchased.setDate(date2, animated: true)
            }
            if self.selectedItem?.sharedUsers?.count ?? 0 > 0 {
                self.sharedByUsers = selectedItem!.sharedUsers!.map{$0.username}
                sharedByTF.text = sharedByUsers.joined(separator: ",")
            }
            if nil != selectedItem?.itemPrice {
                priceTF.text = "\(selectedItem!.itemPrice!)"
            }
            if nil != selectedItem?.boughtBy {
                boughtByTF.text=selectedItem?.boughtBy!.username
            }
        }
        initializeTextFields()
    }
    
    func passTableSelection(data: User) {
        //call update API
        boughtByTF.text=data.username
    }
    
    func passTableSelectionForUsers(data: [User]) {
        print(data)
        self.sharedByUsers = data.map{$0.username}
        sharedByTF.text = sharedByUsers.joined(separator: ",")
    }
    
    @IBAction func getBoughtByUser(_ sender: Any) {
        performSegue(withIdentifier: "useritemsg", sender: self)
    }
    
    
    @IBAction func sharedByUsers(_ sender: Any) {
        performSegue(withIdentifier: "userItemmulsg", sender: self)
    }
    
    func clearFields() {
        sharedByTF.text = ""
        purchased.date = Date()
        boughtByTF.text = ""
        priceTF.text = ""
        itemNameTF.text=""
        completeByTF.date=Date()
        boughtswitch.setOn(false, animated: false)
        yeslbl.text = "No"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func initializeTextFields() {
        boughtByTF.delegate = self
        priceTF.delegate = self
        itemNameTF.delegate = self
        sharedByTF.delegate = self
    }
    
    
    
    @IBAction func create(_ sender: Any) {
        let taskName = "Shopping"
        let taskDesc = "Shopping"
        guard let itemName = itemNameTF.text, !itemName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter valid Item Name")
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let completionDate = formatter.string(from:completeByTF.date)
        let isTaskComplete = boughtswitch.isOn
        if isCreate! {
            createGroupItem(taskName: taskName, taskDescription: taskDesc, completionDate:completionDate, itemName:itemName)
        }
        else {
            guard let itemPrice = priceTF.text, !itemPrice.isEmptyOrWhitespace() else {
                showAlert(title: "Enter correct Price")
                return
            }
            
            
            guard let boughtByUser = boughtByTF.text, !boughtByUser.isEmptyOrWhitespace() else {
                showAlert(title: "Enter Bought By User")
                return
            }
            
            guard let sharedByUsers = sharedByTF.text, !sharedByUsers.isEmptyOrWhitespace() else {
                showAlert(title: "Enter Shared By Users")
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let purchasedOn = formatter.string(from: purchased.date)
            
            
            updateGroupItem(id: selectedItem!.taskId, taskName: taskName, taskDescription: taskDesc, completionDate:completionDate, isTaskComplete: isTaskComplete, itemName: itemName, itemPrice: Double(itemPrice)!, purchasedOnDate: purchasedOn,boughtBy: boughtByUser,sharedUsers: self.sharedByUsers )
        }
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
        case let st as UserInchageViewController:
            st.delegate = self
        case let st as UsersListViewController:
            st.delegate = self
        default:
            print("")
        }
    }
    
    @objc func getGroupItemInfo() {
        GroupItemInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    Singleton.shared.groupItemInfo = successResponse
                    if !self.isCreate! {
                        self.selectedItem = Singleton.shared.groupItemInfo?.filter({$0.taskId == self.selectedItem?.taskId}).first
                    }
                    self.viewWillAppear(true)
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to get Items Info\nPlease try again!")
            })
    }
    
    func createGroupItem(taskName:String,taskDescription:String,completionDate:String,itemName:String) {
        
        ItemRequest(taskName:taskName, taskDescription:taskDescription,completionDate:completionDate,itemName:itemName)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.clearFields()
                    self.getGroupItemInfo()
                    self.showAlert(title:"Item Created Successfully!")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to Create Item\nPlease try again!")
            })
    }
    
    func updateGroupItem(id:String,taskName:String, taskDescription:String,completionDate:String,isTaskComplete:Bool,itemName:String,itemPrice:Double, purchasedOnDate: String, boughtBy:String, sharedUsers:[String]) {
        ItemUpdateRequest(id:id,taskName:taskName, taskDescription:taskDescription,completionDate:completionDate,
                          itemName:itemName,boughtBy:boughtBy,purchasedOnDate:purchasedOnDate,isTaskComplete:isTaskComplete,
                          itemPrice:itemPrice, sharedUsers:sharedUsers)
            
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getGroupItemInfo()
                    self.showAlert(title:"Item Updated Successfully!")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to Update Item\nPlease try again!")
            })
    }
}
