//
//  APIsStructure.swift
//  example
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit


// MARK: - SignUp
struct SignUp: Codable {
    let message: String
}

struct MessaegeResponse:Codable {
    let message: String
}
// MARK: - Signin
struct Signin: Codable {
    let id: Int
    let username, email: String
    let roles: [String]
    let accessToken, tokenType: String
}


// MARK: - CreateGroup
struct CreateGroup: Codable {
    let message: String
}


// MARK: - InviteUsers
struct InviteUsers: Codable {
    let message: String
}

struct JoinGroup: Codable {
    let message: String
}
struct UpdateGroup: Codable {
    let message: String
}

// MARK: - GroupInfo
struct GroupInfo: Codable {
    let id, groupId: Int
    let groupName, groupDescription: String
    let users: [User]
    
}

// - User
struct User: Codable {
    let id: Int
    let username, email, firstName, lastName: String
    let phoneNo: Int
    let roles: [Role]
}

// Role
struct Role: Codable {
    let name: String
}


// MARK: - Profile
struct Profile: Codable {
    let id: Int
    let username, email, firstName, lastName: String
    let phoneNo: Int
    let roles: [Role]
}


// MARK: - Task
struct Task: Codable {
    let taskId, taskName, taskType, taskStatus: String
    let taskDescription, creationDate, completionDate: String
    let addedByUser: User
    let isTaskComplete, isTaskUpForSwap: Bool
    let userInCharge: User
}


// MARK: - Task
struct Item: Codable {
    let taskId, taskName, taskType, taskStatus: String
    let taskDescription, creationDate, completionDate, itemName:String
    let purchasedOnDate: String?
    let addedByUser: User
    let isTaskComplete: Bool
    let itemPrice:Double?
    let sharedUsers:[User]?
    let boughtBy: User?
}

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let timestamp :String
    let status: Int
    let error: String
    let message: String
    let path: String
}
