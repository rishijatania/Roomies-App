//
//  Singleton.swift
//  Assignment6
//
//  Created by Rishi Jatania on 3/14/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class Singleton:NSObject {
    var userCreds:Signin?
    var userGroupInfo:GroupInfo?
    var userInfo:User?
    var groupTaskInfo:[Task]?
    var groupItemInfo:[Item]?
    
    static let shared = Singleton()
    // Initialization
    private override init() {
    }
    
    func logout() {
        userCreds = nil
        userGroupInfo = nil
        userInfo = nil
        groupTaskInfo = nil
        groupItemInfo = nil
    }
    
    func checkfornetwork() -> Bool {
        if !reachability() {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let appscene = OfflineViewController.instantiateFromAppStoryBoard(appStoryBoard: .Main)
            appDelegate.window?.rootViewController = appscene
            appDelegate.window?.makeKeyAndVisible()
            return false
        }
        return true
    }
    
    func reachability() -> Bool {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, Constant.URL_SLACK) else { return false}
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if !isNetworkReachable(with: flags) {
            // Device doesn't have internet connection
            print("network not reachable");
            return false
        }
        print("network reachable");
        
        return true
    }
    
    func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}
