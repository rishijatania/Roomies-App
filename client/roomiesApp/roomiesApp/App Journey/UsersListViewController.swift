//
//  UsersListViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

protocol UsersListViewControllerDelegate : NSObjectProtocol{
    func passTableSelectionForUsers(data: [User])
}

class UsersListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var filteredTableData = [User]()
    var resultSearchController = UISearchController()
    weak var delegate:UsersListViewControllerDelegate?
    var selectedUsers:[User]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cell = UINib(nibName: "UserInfoTableViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "UserCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.estimatedRowHeight = 600
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        }
        else {
            return Singleton.shared.userGroupInfo?.users.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserInfoTableViewCell
        let user:User?
        
        if (resultSearchController.isActive) {
            user = filteredTableData[indexPath.row]
        }
        else {
            user = Singleton.shared.userGroupInfo?.users[indexPath.row]
        }
        
        cell.userNameTF.text=user!.username
        cell.nameTF.text=user!.firstName + " " + user!.lastName
        cell.emailTF.text=user!.email
        if user?.roles.filter({$0.name.contains("GRADMIN")}).first != nil {
            cell.roleTF.text="GRADMIN"
        }
        else{
            cell.roleTF.text="USER"
        }
        return cell
    }
    
    @IBAction func done(_ sender: Any) {
        if let delegate = delegate{
            delegate.passTableSelectionForUsers(data: self.selectedUsers)
        }
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user:User? = Singleton.shared.userGroupInfo?.users[indexPath.row]
        selectedUsers.append(user!)
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let user:User? = Singleton.shared.userGroupInfo?.users[indexPath.row]
        selectedUsers.removeAll(where: {$0.username == user?.username })
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        filteredTableData = Singleton.shared.userGroupInfo!.users.filter({$0.username.contains(searchController.searchBar.text!)})
        self.tableView.reloadData()
    }
    
}
