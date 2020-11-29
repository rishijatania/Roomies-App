//
//  CreateTaskViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UITextFieldDelegate, UserInchageViewControllerDelegate{
    
    @IBOutlet weak var taskNameTf: UITextField!
    @IBOutlet weak var taskDescTF: UITextField!
    @IBOutlet weak var userInChargeTF: UITextField!
    @IBOutlet weak var taskDateTF: UIDatePicker!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var addedByUserTF: UITextField!
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var swaplbl: UILabel!
    @IBOutlet weak var swapSwitch: UISwitch!
    @IBOutlet weak var createTaskBtn: UIButton!
    var isCreate:Bool?
    var selectedTask:Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskDateTF.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func complete(_ sender: UISwitch) {
        if sender.isOn {
            swapSwitch.setOn(false, animated: true)
            completedLbl.text = "Yes"
            swaplbl.text="No"
        }
        else{
            completedLbl.text = "No"
        }
    }
    
    @IBAction func swap(_ swap: UISwitch) {
        if swap.isOn {
            completedSwitch.setOn(false, animated: true)
            swaplbl.text="Yes"
            completedLbl.text="No"
        }
        else{
            swaplbl.text="No"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isCreate! {
            createTaskBtn.setTitle("Create", for: .normal)
            self.navigationItem.title="Create Task"
            completedSwitch.isUserInteractionEnabled = false
            completedSwitch.setOn(false, animated: true)
            addedByUserTF.text=Singleton.shared.userInfo?.username
        }
        else{
            let complete = selectedTask?.isTaskComplete == nil ? false :  selectedTask!.isTaskComplete
            if !complete {
                createTaskBtn.setTitle("Update", for: .normal)
                self.navigationItem.title="Update Task"
                createTaskBtn.isHidden=false
            }
            else {
                createTaskBtn.isHidden=true
                completedSwitch.isUserInteractionEnabled = false
                swapSwitch.isUserInteractionEnabled = false
            }
            completedSwitch.setOn(complete, animated: true)
            
            taskNameTf.text=selectedTask?.taskName
            taskDescTF.text=selectedTask?.taskDescription
            userInChargeTF.text=selectedTask?.userInCharge.username
            addedByUserTF.text=selectedTask?.addedByUser.username
            let isoDate = selectedTask?.completionDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:isoDate!)!
            taskDateTF.setDate(date, animated: true)
            
            swapSwitch.setOn(selectedTask?.isTaskUpForSwap == nil ? false :  selectedTask!.isTaskUpForSwap, animated: true)
            
        }
        initializeTextFields()
    }
    
    @IBAction func getUserInCharge(_ sender: Any) {
        performSegue(withIdentifier: "usertasksg", sender: self)
    }
    
    
    @IBAction func create(_ sender: Any) {
        guard let taskName = taskNameTf.text, !taskName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct Task Name")
            return
        }
        guard let taskDesc = taskDescTF.text, !taskDesc.isEmptyOrWhitespace() else {
            showAlert(title: "Enter valid Task Description")
            return
        }
        
        guard let userInCharge = userInChargeTF.text, !userInCharge.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct User In Charge")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let completionDate = formatter.string(from: taskDateTF.date)
        let isTaskComplete = completedSwitch.isOn
        let isTaskUpForSwap = swapSwitch.isOn
        if isCreate! {
            createGroupTask(taskName: taskName, userInCharge: userInCharge, taskDescription: taskDesc, completionDate:completionDate, isTaskComplete: isTaskComplete, isTaskUpForSwap: isTaskUpForSwap)
        }
        else {
            updateGroupTask(id: selectedTask!.taskId, taskName: taskName, userInCharge: userInCharge, taskDescription: taskDesc, completionDate:completionDate, isTaskComplete: isTaskComplete, isTaskUpForSwap: isTaskUpForSwap)
        }
    }
    
    func passTableSelection(data: User) {
        //call update API
        userInChargeTF.text=data.username
    }
    
    func clearFields() {
        taskNameTf.text=""
        taskDescTF.text=""
        userInChargeTF.text=""
        taskDateTF.date = Date()
        completedSwitch.setOn(false, animated: true)
        swapSwitch.setOn(false, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func initializeTextFields() {
        taskNameTf.delegate=self
        taskDescTF.delegate=self
        userInChargeTF.delegate=self
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
        default:
            print("")
        }
    }
    
    @objc func getGroupTaskInfo() {
        GroupTaskInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    Singleton.shared.groupTaskInfo=successResponse
                    if !self.isCreate! {
                        self.selectedTask = Singleton.shared.groupTaskInfo?.filter({$0.taskId == self.selectedTask?.taskId}).first
                    }
                    self.viewWillAppear(true)
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to get Tasks Info\nPlease try again!")
            })
    }
    
    func createGroupTask(taskName:String,userInCharge:String, taskDescription:String,completionDate:String,isTaskComplete:Bool, isTaskUpForSwap:Bool) {
        
        TaskRequest(taskName:taskName,userInCharge:userInCharge, taskDescription:taskDescription,completionDate:completionDate,isTaskComplete:isTaskComplete, isTaskUpForSwap:isTaskUpForSwap)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.clearFields()
                    self.getGroupTaskInfo()
                    self.showAlert(title:"Task Created Successfully!")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to Create Task\nPlease try again!")
            })
    }
    
    func updateGroupTask(id:String,taskName:String,userInCharge:String, taskDescription:String,completionDate:String,isTaskComplete:Bool, isTaskUpForSwap:Bool) {
        TaskUpdateRequest(id:id,taskName:taskName,userInCharge:userInCharge, taskDescription:taskDescription,completionDate:completionDate,isTaskComplete:isTaskComplete, isTaskUpForSwap:isTaskUpForSwap )
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getGroupTaskInfo()
                    self.showAlert(title:"Task Updated Successfully!")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to Update Task\nPlease try again!")
            })
    }
    
}
