//
//  ItemDetailsViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var itemNameLbl: UITextField!
    @IBOutlet weak var completeByLbl: UIDatePicker!
    @IBOutlet weak var purchasedOn: UIDatePicker!
    @IBOutlet weak var boughtSwitch: UISwitch!
    @IBOutlet weak var yesLbl: UILabel!
    @IBOutlet weak var boughtSwitchLbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var boughtByUTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var sharedByUTF: UITextField!
    @IBOutlet weak var boughtByUlbl: UILabel!
    @IBOutlet weak var sharedByLbl: UILabel!
    @IBOutlet weak var purchasedOnlbl: UILabel!
    var selectedItem:Item?
    override func viewDidLoad() {
        super.viewDidLoad()
        purchasedOn.backgroundColor = .white
        completeByLbl.backgroundColor = .white
        // Do any additional setup after loading the view.
        viewWillAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedItem = Singleton.shared.groupItemInfo?.filter({$0.taskId == selectedItem?.taskId}).first
        boughtSwitch.setOn(selectedItem?.isTaskComplete ?? false, animated: true)
        if !selectedItem!.isTaskComplete {
            sharedByLbl.isHidden = true
            sharedByUTF.isHidden = true
            purchasedOnlbl.isHidden = true
            purchasedOn.isHidden = true
            boughtByUlbl.isHidden = true
            boughtByUTF.isHidden = true
            priceTF.isHidden = true
            pricelbl.isHidden = true
        }
        else {
            sharedByLbl.isHidden = false
            sharedByUTF.isHidden = false
            purchasedOnlbl.isHidden = false
            purchasedOn.isHidden = false
            boughtByUlbl.isHidden = false
            boughtByUTF.isHidden = false
            priceTF.isHidden = false
            pricelbl.isHidden = false
            self.navigationItem.rightBarButtonItem = nil
        }
        itemNameLbl.text = selectedItem?.itemName
        if nil != selectedItem{
            let isoDate = selectedItem?.completionDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:isoDate!)!
            completeByLbl.setDate(date, animated: true)
        }
        yesLbl.text = boughtSwitch.isOn ? "Yes":"No"
        if nil != selectedItem?.purchasedOnDate {
            let isodate2 = selectedItem?.purchasedOnDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date2 = dateFormatter.date(from:isodate2!)!
            purchasedOn.setDate(date2, animated: true)
        }
        if self.selectedItem?.sharedUsers?.count ?? 0 > 0 {
            let sharedByUsers = selectedItem!.sharedUsers!.map{$0.username}
            sharedByUTF.text = sharedByUsers.joined(separator: ",")
        }
        if nil != selectedItem?.itemPrice {
            priceTF.text = "\(selectedItem!.itemPrice!)"
        }
        boughtByUTF.text=selectedItem?.boughtBy?.username
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
        case let ct as ItemCreateViewController:
            ct.isCreate=false
            ct.selectedItem = self.selectedItem
        default:
            print("")
        }
    }
    
}
