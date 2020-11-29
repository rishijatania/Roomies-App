//
//  TaskDetailsViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController, SwapTaskViewControllerDelegate {
    
    @IBOutlet weak var taskNameTF: UITextField!
    @IBOutlet weak var TaskDescTF: UITextField!
    @IBOutlet weak var userInChargeTF: UITextField!
    @IBOutlet weak var completionDateTF: UIDatePicker!
    @IBOutlet weak var completedswitch: UISwitch!
    @IBOutlet weak var completeLbl: UILabel!
    @IBOutlet weak var swaplbl: UILabel!
    @IBOutlet weak var addedByUser: UITextField!
    var selectedTask:Task?
    var isFromGroupTask:Bool=false
    @IBOutlet weak var swapswitch: UISwitch!
    @IBOutlet weak var swapBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        completionDateTF.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedTask = Singleton.shared.groupTaskInfo?.filter({$0.taskId == selectedTask?.taskId}).first
        swapswitch.setOn(selectedTask?.isTaskUpForSwap ?? false, animated: true)
        if isFromGroupTask{
            swapBtn.isHidden = true
        }
        else if !swapswitch.isOn  {
            swapBtn.isHidden = true
        }
        else {
            swapBtn.isHidden = false
        }
        taskNameTF.text = selectedTask?.taskName
        TaskDescTF.text = selectedTask?.taskDescription
        userInChargeTF.text = selectedTask?.userInCharge.username
        if nil != selectedTask{
            let isoDate = selectedTask?.completionDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:isoDate!)!
            completionDateTF.setDate(date, animated: true)
        }
        completedswitch.setOn(selectedTask?.isTaskComplete ?? false, animated: true)
        completeLbl.text = completedswitch.isOn ? "Yes":"No"
        swaplbl.text = swapswitch.isOn ? "Yes":"No"
        addedByUser.text = selectedTask?.addedByUser.username
        if selectedTask?.isTaskComplete ?? false {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func passTableSelection(data: Task) {
        //call update API
        swapTask(taskinfo1:self.selectedTask!,taskinfo2:data)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc:UIViewController = segue.destination
        switch vc {
        case let st as SwapTaskViewController:
            st.isFromGroupTask = false
            st.isForSwapTask = true
            st.delegate = self
            st.tasktoswapwith = self.selectedTask
        case let ct as CreateTaskViewController:
            ct.isCreate=false
            ct.selectedTask = self.selectedTask
        default:
            print("")
        }
    }
    func showAlert(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    @objc func getGroupTaskInfo(_ fromswap:Bool) {
        GroupTaskInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    Singleton.shared.groupTaskInfo=successResponse
                    if fromswap {
                        
                        self.selectedTask = Singleton.shared.groupTaskInfo?.filter({$0.taskId == self.selectedTask?.taskId}).first
                        self.navigationItem.rightBarButtonItem = nil
                        self.viewWillAppear(true)
                        self.showAlert(title:"Task Swaped Successfully!")
                    }
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to get Tasks Info\nPlease try again!")
            })
    }
    
    
    func swapTask(taskinfo1:Task,taskinfo2:Task) {
        TaskUpdateRequest(id:taskinfo1.taskId,taskName:taskinfo1.taskName,userInCharge:taskinfo2.userInCharge.username, taskDescription:taskinfo1.taskDescription,completionDate:taskinfo1.completionDate,isTaskComplete:false, isTaskUpForSwap:false )
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getGroupTaskInfo(false)
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to Swap task from Swap list Task\nPlease try again!")
            })
        
        TaskUpdateRequest(id:taskinfo2.taskId,taskName:taskinfo2.taskName,userInCharge:taskinfo1.userInCharge.username, taskDescription:taskinfo2.taskDescription,completionDate:taskinfo2.completionDate,isTaskComplete:false, isTaskUpForSwap:false )
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getGroupTaskInfo(true)
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to Swap task from Swap list Task\nPlease try again!")
            })
    }
}
