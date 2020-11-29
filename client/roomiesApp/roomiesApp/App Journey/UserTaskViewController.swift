//
//  UserTaskViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class UserTaskViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var isPendingTask:Bool = true
    var isSwapTask:Bool = false
    var selectedTask:Task?
    var filteredTableData = [Task]()
    var resultSearchController = UISearchController()
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getGroupTaskInfo()
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
    
    @IBAction func pendingTasks(_ sender: Any) {
        isPendingTask=true
        isSwapTask=false
        tableView.reloadData()
    }
    
    @IBAction func completeTasks(_ sender: Any) {
        isPendingTask=false
        isSwapTask=false
        tableView.reloadData()
    }
    @IBAction func swapTask(_ sender: Any) {
        isSwapTask=true
        isPendingTask=false
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            if isSwapTask {
                return Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && $0.isTaskUpForSwap && $0.userInCharge.username == Singleton.shared.userInfo?.username}).count ?? 0
            }
            else if isPendingTask {
                return Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && !$0.isTaskUpForSwap && $0.userInCharge.username == Singleton.shared.userInfo?.username}).count ?? 0
            }
            else {
                return Singleton.shared.groupTaskInfo?.filter({$0.isTaskComplete && !$0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                }).count ?? 0
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
            if isSwapTask {
                task = Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && $0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })[indexPath.row]
                cell.statuslbl.text="SWAP"
            }
            else if isPendingTask {
                task = Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && !$0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })[indexPath.row]
                cell.statuslbl.text=task?.taskStatus
            }
            else{
                task = Singleton.shared.groupTaskInfo?.filter({$0.isTaskComplete && !$0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })[indexPath.row]
                cell.statuslbl.text=task?.taskStatus
            }
        }
        cell.taskNamelbl.text=task?.taskName
        cell.taskDesc.text=task?.taskDescription
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
            let tasktodelete:Task?
            if isSwapTask {
                tasktodelete = Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && $0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })[indexPath.row]
            }
            else if isPendingTask {
                tasktodelete = Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && !$0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })[indexPath.row]
            }
            else{
                tasktodelete = Singleton.shared.groupTaskInfo?.filter({$0.isTaskComplete && !$0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })[indexPath.row]
            }
            
            deleteGroupTask(id:Int(tasktodelete!.taskId)!)
            Singleton.shared.groupTaskInfo?.removeAll(where: { $0.taskId == tasktodelete?.taskId})
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        if Singleton.shared.groupTaskInfo != nil {
            if isSwapTask {
                filteredTableData  = Singleton.shared.groupTaskInfo!.filter({$0.taskName.contains(searchController.searchBar.text!) && !$0.isTaskComplete && $0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })
            }
            else if isPendingTask {
                filteredTableData  = Singleton.shared.groupTaskInfo!.filter({$0.taskName.contains(searchController.searchBar.text!) && !$0.isTaskComplete && !$0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })
            }else{
                filteredTableData  = Singleton.shared.groupTaskInfo!.filter({$0.taskName.contains(searchController.searchBar.text!) && $0.isTaskComplete && !$0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })
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
            if isSwapTask{
                self.selectedTask = Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && $0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })[indexPath.row]
            }
            else if isPendingTask {
                self.selectedTask = Singleton.shared.groupTaskInfo?.filter({!$0.isTaskComplete && !$0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })[indexPath.row]
            }
            else{
                self.selectedTask = Singleton.shared.groupTaskInfo?.filter({$0.isTaskComplete && !$0.isTaskUpForSwap
                    && $0.userInCharge.username == Singleton.shared.userInfo?.username
                })[indexPath.row]
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "userDetailssg", sender: self)
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
            td.isFromGroupTask = false
        case let ct as CreateTaskViewController:
            ct.isCreate = true
        default:
            print("")
        }
        
    }
    
    func showAlert(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
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
