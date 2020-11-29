//
//  GroupTaskViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/20/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit
import Foundation

class GroupTaskViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var completeItem: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    var filteredTableData = [Task]()
    var resultSearchController = UISearchController()
    private let refreshControl = UIRefreshControl()
    var isPendingTask:Bool = true
    var selectedTask:Task?
    @IBAction func completeTaskAction(_ sender: Any) {
        isPendingTask=false
        tableView.reloadData()
    }
    @IBAction func pendingTaskAction(_ sender: Any) {
        isPendingTask=true
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupTaskInfo()
        getUserInfo()
        refreshControl.addTarget(self, action: #selector(getGroupTaskInfo), for: .valueChanged)
        // Do any additional setup after loading the view.
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        tableView.delegate = self
        tableView.dataSource = self
        let cell = UINib(nibName: "GroupTaskTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "cell")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            if isPendingTask {
                return Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && !$0.isTaskUpForSwap}).count ?? 0
            }else {
                return Singleton.shared.groupTaskInfo?.filter({$0.isTaskComplete && !$0.isTaskUpForSwap}).count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupTaskTableViewCell
        var task:Task?
        
        if (resultSearchController.isActive) {
            task = filteredTableData[indexPath.row]
        }
        else {
            if isPendingTask {
                task = Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && !$0.isTaskUpForSwap})[indexPath.row]
            }
            else{
                task = Singleton.shared.groupTaskInfo?.filter({$0.isTaskComplete && !$0.isTaskUpForSwap})[indexPath.row]
            }
        }
        cell.taskNamelbl.text=task?.taskName
        cell.taskDesc.text=task?.taskDescription
        cell.statuslbl.text=task?.taskStatus
        cell.completionDate.text=task?.completionDate
        cell.userInCharge.text=task?.userInCharge.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            Singleton.shared.trains.trainList.remove(at: indexPath.row)
            //API Call
            let ele = Singleton.shared.userInfo?.roles.filter({$0.name.contains("GRADMIN")})
            if ele != nil && !ele!.isEmpty {
                let tasktodelete:Task?
                if isPendingTask {
                    tasktodelete = Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && !$0.isTaskUpForSwap})[indexPath.row]
                }
                else{
                    tasktodelete = Singleton.shared.groupTaskInfo?.filter({$0.isTaskComplete && !$0.isTaskUpForSwap})[indexPath.row]
                }
                deleteGroupTask(id:Int(tasktodelete!.taskId)!)
                Singleton.shared.groupTaskInfo?.removeAll(where: { $0.taskId == tasktodelete?.taskId})
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else{
                showAlert(title: "User Cannot Delete Tasks From Groups Tab")
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        if Singleton.shared.groupTaskInfo != nil {
            if isPendingTask {
                filteredTableData  = Singleton.shared.groupTaskInfo!.filter({$0.taskName.contains(searchController.searchBar.text!) && !$0.isTaskComplete && !$0.isTaskUpForSwap})
            }else{
                filteredTableData  = Singleton.shared.groupTaskInfo!.filter({$0.taskName.contains(searchController.searchBar.text!) && $0.isTaskComplete && !$0.isTaskUpForSwap})
            }
        }
        else{
            filteredTableData = []
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (resultSearchController.isActive) {
            self.selectedTask = filteredTableData[indexPath.row]
        }
        else {
            if isPendingTask {
                self.selectedTask = Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && !$0.isTaskUpForSwap})[indexPath.row]
            }
            else{
                self.selectedTask = Singleton.shared.groupTaskInfo?.filter({$0.isTaskComplete && !$0.isTaskUpForSwap})[indexPath.row]
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "grpDetailssg", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        self.tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc:UIViewController = segue.destination
        switch vc {
        case let td as TaskDetailsViewController:
            td.selectedTask = self.selectedTask
            td.isFromGroupTask = true
        case let st as SwapTaskViewController:
            st.isFromGroupTask = true
        default:
            print("")
        }
        
    }
    
    func showAlert(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func getUserInfo () {
        UserInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    Singleton.shared.userInfo=successResponse
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    Singleton.shared.userInfo=nil
                    self.showAlert(title:errorResponse?.message ?? "Unable to get User Info\nPlease try Login In again!")
            })
    }
    
    @objc func getGroupTaskInfo() {
        GroupTaskInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    Singleton.shared.groupTaskInfo=successResponse
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to get Tasks Info\nPlease try again!")
            })
    }
    
    
    func deleteGroupTask(id:Int) {
        TaskDeleteRequest(id:id)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getGroupTaskInfo()
                    self.showAlert(title:"Task Deleted Successfully!")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.getGroupTaskInfo()
                    self.showAlert(title:errorResponse?.message ?? "Unable to Delete Task\nPlease try again!")
            })
    }
}
