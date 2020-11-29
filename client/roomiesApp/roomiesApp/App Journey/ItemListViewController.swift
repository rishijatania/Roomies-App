//
//  ItemListViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var filteredTableData = [Item]()
    var resultSearchController = UISearchController()
    private let refreshControl = UIRefreshControl()
    var isPendingTask:Bool = true
    var selectedItem:Item?
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupItemInfo()
        refreshControl.addTarget(self, action: #selector(getGroupItemInfo), for: .valueChanged)
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
        let cell = UINib(nibName: "ItemInfoTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    @IBAction func pendingAction(_ sender: Any) {
        isPendingTask=true
        tableView.reloadData()
    }
    
    @IBAction func boughtAction(_ sender: Any) {
        isPendingTask=false
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            if isPendingTask {
                return Singleton.shared.groupItemInfo?.filter({!$0.isTaskComplete}).count ?? 0
            }else {
                return Singleton.shared.groupItemInfo?.filter({$0.isTaskComplete}).count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemInfoTableViewCell
        var item:Item?
        
        if (resultSearchController.isActive) {
            item = filteredTableData[indexPath.row]
        }
        else {
            if isPendingTask {
                item = Singleton.shared.groupItemInfo?.filter({!$0.isTaskComplete})[indexPath.row]
            }
            else{
                item = Singleton.shared.groupItemInfo?.filter({$0.isTaskComplete})[indexPath.row]
            }
        }
        cell.itemNamelbl.text=item?.itemName ?? ""
        cell.boughtBylbl.text=item?.boughtBy?.username ?? ""
        cell.statuslbl.text=item?.taskStatus
        cell.dateLbl.text=item?.purchasedOnDate ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            Singleton.shared.trains.trainList.remove(at: indexPath.row)
            //API Call
            let itemtodelete:Item?
            if isPendingTask {
                itemtodelete = Singleton.shared.groupItemInfo?.filter({!$0.isTaskComplete})[indexPath.row]
            }
            else{
                itemtodelete = Singleton.shared.groupItemInfo?.filter({$0.isTaskComplete})[indexPath.row]
            }
            deleteGroupItem(id:itemtodelete!.taskId)
            Singleton.shared.groupItemInfo?.removeAll(where: { $0.taskId == itemtodelete?.taskId})
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        if Singleton.shared.groupItemInfo != nil {
            if isPendingTask {
                filteredTableData  = Singleton.shared.groupItemInfo!.filter({$0.itemName.contains(searchController.searchBar.text!) && !$0.isTaskComplete
                })
            }else{
                filteredTableData  = Singleton.shared.groupItemInfo!.filter({$0.itemName.contains(searchController.searchBar.text!) && $0.isTaskComplete
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
            self.selectedItem = filteredTableData[indexPath.row]
        }
        else {
            if isPendingTask {
                self.selectedItem = Singleton.shared.groupItemInfo?.filter({!$0.isTaskComplete
                })[indexPath.row]
            }
            else{
                self.selectedItem = Singleton.shared.groupItemInfo?.filter({$0.isTaskComplete
                })[indexPath.row]
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "itemDetailsg", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc:UIViewController = segue.destination
        switch vc {
        case let td as ItemDetailsViewController:
            td.selectedItem = self.selectedItem
        //            td.isFromItem = false
        case let ct as ItemCreateViewController:
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
    
    @objc func getGroupItemInfo() {
        GroupItemInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    Singleton.shared.groupItemInfo=successResponse
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Unable to get Items Info\nPlease try again!")
            })
    }
    
    func deleteGroupItem(id:String) {
        ItemDeleteRequest(id:id)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getGroupItemInfo()
                    self.showAlert(title:"Item Deleted Successfully!")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.getGroupItemInfo()
                    self.showAlert(title:errorResponse?.message ?? "Unable to Delete Item\nPlease try again!")
            })
    }
    
}
