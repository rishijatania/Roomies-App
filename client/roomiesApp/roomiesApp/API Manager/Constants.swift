//
//  Constants.swift
//  roomiesApp
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import Foundation

class Constant: NSObject {
    static let URL = "http://localhost:8080/api"
    static let URL_SIGNIN = "/auth/signin"
    static let URL_SIGNUP = "/auth/signup"
    static let URL_GROUP_CREATE = "/home/createGroup"
    static let URL_GROUP_JOIN = "/home/joinGroup"
    static let URL_GROUP_INVITE = "/home/inviteUsers"
    static let URL_GROUP_UPDATE = "/home/updateGroupInfo"
    static let URL_GROUP_INFO = "/home/groupInfo"
    static let URL_USER_INFO = "/home/profile"
    static let URL_GROUP_TASK_INFO = "/home/tasks"
    static let URL_USER_TASK_INFO = "/home/tasks/self"
    static let URL_USER_TASK_CREATE = "/home/task"
    static let URL_USER_TASK_DELETE = "/home/task/"
    static let URL_USER_TASK_UPDATE = "/home/task/"
    static let URL_SLACK = "https://hooks.slack.com"
    static let URL_USER_REPORT_BUG = "/services/TSU2P26GZ/B01346H8PB2/rQssnIhCf5AebwBi49JbutJ9"
    static let URL_GROUP_ITEM_INFO  = "/home/items"
    static let URL_GROUP_ITEM_CREATE  = "/home/item"
    static let URL_GROUP_ITEM_DELETE = "/home/item/"
    static let URL_GROUP_ITEM_UPDATE = "/home/item/"
    
}
