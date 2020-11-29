//
//  GroupInfoViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class GroupInfoViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var grpName: UITextField!
    @IBOutlet weak var grpDesc: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: #selector(getGroupInfo(_:)), for: .valueChanged)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cell = UINib(nibName: "UserInfoTableViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "UserCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.estimatedRowHeight = 600
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        
        self.tableView.reloadData()
        initializeTextFields()
        setFields()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func setFields(){
        grpName.text = Singleton.shared.userGroupInfo?.groupName
        grpDesc.text = Singleton.shared.userGroupInfo?.groupDescription
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        guard let groupName = grpName.text, !groupName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct Group Name")
            return
        }
        guard let groupDesc = grpDesc.text, !groupDesc.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct Description")
            return
        }
        self.perfromGroupInfoUpdate(grpName:groupName,grpDesc:groupDesc)
    }
    @IBAction func invite(_ sender: Any) {
        promptForAnswer()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shared.userGroupInfo?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserInfoTableViewCell
        //        cell.textLabel?.text = userarray[indexPath.row]
        let user = Singleton.shared.userGroupInfo?.users[indexPath.row]
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
    
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter User Email", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            guard let email = ac.textFields![0].text, email.isValidEmail() else{
                self.showAlert(title: "Enter Valid Email")
                return
            }
            // do something interesting with "answer" here
            self.performGroupInvite(grpName:self.grpName.text!,grpDesc:self.grpDesc.text!,email:email)
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func initializeTextFields() {
        grpName.delegate=self
        grpDesc.delegate=self
    }
    
    func showAlert(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func perfromGroupInfoUpdate(grpName:String,grpDesc:String){
        UpdateGroupInfoRequest(groupName: grpName, groupDescription: grpDesc)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getGroupInfo(true)
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.setFields()
                    self.showAlert(title:errorResponse?.message ?? "Bad Request\nPlease try Login In again!")
                    
            })
        
    }
    
    func performGroupInvite(grpName:String,grpDesc:String,email:String){
        InviteUsersRequest(groupName: grpName, groupDescription: grpDesc, users: [email])
            .dispatch(
                onSuccess: { (successResponse) in
                    self.getGroupInfo(false)
                    self.showAlert(title:"User Invited Successfully")
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.showAlert(title:errorResponse?.message ?? "Bad Request\nPlease try Login In again!")
                    
            })
    }
    
    @objc func getGroupInfo (_ fromUpdate:Bool ) {
        GroupInfoRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    Singleton.shared.userGroupInfo=successResponse
                    self.setFields()
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    if fromUpdate {
                        self.showAlert(title:"Group Info Updated Successfully")
                    }
            },
                onFailure: { (errorResponse, error) in
                    print(errorResponse?.message ?? "")
                    self.setFields()
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.showAlert(title:errorResponse?.message ?? "Bad Request\nPlease try Login In again!")
                    
            })
    }
}
