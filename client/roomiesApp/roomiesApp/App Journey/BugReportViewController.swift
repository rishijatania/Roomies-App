//
//  BugReportViewController.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/23/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

class BugReportViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var issueTF: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func showAlert(title: String){
        let alert = UIAlertController(title:title, message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func initializeTextFields() {
        issueTF.delegate=self
    }
    
    @IBAction func send(_ sender: Any) {
        guard let taskName = issueTF.text, !taskName.isEmptyOrWhitespace() else {
            showAlert(title: "Enter correct Issue Details")
            return
        }
        
        let fields:[ReportElements] = [
            ReportElements(title: "Username", value: Singleton.shared.userInfo!.username, short: true),
            ReportElements(title: "Bug", value: issueTF.text, short: false)
        ]
        ReportBugRequest(fields: fields)
            .dispatch(
                onSuccess: { (successResponse) in
                    self.issueTF.text=""
                    self.showAlert(title:"Bug Reported Successfully!")
                    
            },
                onFailure: { (errorResponse, error) in
                    self.issueTF.text=""
                    self.showAlert(title:"Bug Reported Successfully!")
            })
    }
    
}
