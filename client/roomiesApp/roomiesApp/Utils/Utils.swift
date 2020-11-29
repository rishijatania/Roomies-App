//
//  Utils.swift
//  Assignment6
//
//  Created by Rishi Jatania on 3/14/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    func isValidDate() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"
        
        if dateFormatter.date(from: self) != nil {
            return true
        }
        return false
    }
    
    func isNumeric() -> Bool {
        return Double(self) != nil
    }
    
    mutating func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
}

extension UIViewController {
    
    class var storyBoardId:String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryBoard(appStoryBoard: AppStoryboard) -> Self {
        return appStoryBoard.viewController(viewControllerClass: self)
    }
    
}

enum AppStoryboard :String {
    case Main, App
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass: T.Type) -> T {
        let storyBoardId = (viewControllerClass as UIViewController.Type).storyBoardId
        return instance.instantiateViewController(withIdentifier: storyBoardId) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
