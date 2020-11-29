//
//  SwapTaskViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

protocol SwapTaskViewControllerDelegate : NSObjectProtocol{
    func passTableSelection(data: Task)
}

class SwapTaskViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var isFromGroupTask:Bool?
    var filteredTableData = [Task]()
    var resultSearchController = UISearchController()
    private let refreshControl = UIRefreshControl()
    private let isTaskUpForSwap = true
    weak var delegate:SwapTaskViewControllerDelegate?
    var isForSwapTask:Bool=false
    var tasktoswapwith:Task?
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupTaskInfo(false)
        // Do any additional setup after loading the view.
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
            if isForSwapTask {
                return Singleton.shared.groupTaskInfo?.filter({$0.isTaskUpForSwap && $0.taskId != self.tasktoswapwith?.taskId}).count ?? 0
            }
            else {
                return Singleton.shared.groupTaskInfo?.filter({$0.isTaskUpForSwap}).count ?? 0
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
            if isForSwapTask {
                task = Singleton.shared.groupTaskInfo?.filter({$0.isTaskUpForSwap && $0.taskId != self.tasktoswapwith?.taskId})[indexPath.row]
            }
            else {
                task = Singleton.shared.groupTaskInfo?.filter({$0.isTaskUpForSwap})[indexPath.row]
            }
        }
        cell.taskNamelbl.text=task?.taskName
        cell.taskDesc.text=task?.taskDescription
        cell.statuslbl.text="SWAP"
        cell.completionDate.text=task?.completionDate
        cell.userInCharge.text=task?.userInCharge.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isForSwapTask{
            let task:Task? = Singleton.shared.groupTaskInfo?.filter({$0.isTaskUpForSwap && $0.taskId != self.tasktoswapwith?.taskId})[indexPath.row]
            self.tableView.deselectRow(at: indexPath, animated: true)
            if let delegate = delegate{ 
                delegate.passTableSelection(data: task!)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if !isForSwapTask {
            if editingStyle == .delete {
                //API Call
                updateGroupTask(taskinfo: Singleton.shared.groupTaskInfo!.filter({$0.isTaskUpForSwap})[indexPath.row])
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        if Singleton.shared.groupTaskInfo != nil {
            if isForSwapTask {
                filteredTableData = Singleton.shared.groupTaskInfo!.filter({$0.taskName.contains(searchController.searchBar.text!)
                    && $0.isTaskUpForSwap && $0.taskId != self.tasktoswapwith?.taskId
                })
            }
            else {
                filteredTableData  = Singleton.shared.groupTaskInfo!.filter({$0.taskName.contains(searchController.searchBar.text!)
                    && $0.isTaskUpForSwap
                })
            }
        }
        else{
            filteredTableData = []
        }
        self.tableView.reloadData()
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
    
    func showAlert(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func getGroupTaskInfo(_ fromUpdate:Bool) {
        GroupTaskInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    Singleton.shared.groupTaskInfo=successResponse
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    if fromUpdate {
                        self.showAlert(title:"Task Removed from Swap List Successfully!")
                    }
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to get Tasks Info\nPlease try again!")
            })
    }
    
    
    func updateGroupTask(taskinfo:Task) {
        TaskUpdateRequest(id:taskinfo.taskId,taskName:taskinfo.taskName,userInCharge:taskinfo.userInCharge.username, taskDescription:taskinfo.taskDescription,completionDate:taskinfo.completionDate,isTaskComplete:false, isTaskUpForSwap:false )
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getGroupTaskInfo(true)
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.getGroupTaskInfo(false)
                    self.showAlert(title:errorResponse?.message ?? "Unable to Remove task from Swap list Task\nPlease try again!")
            })
    }
    
}
