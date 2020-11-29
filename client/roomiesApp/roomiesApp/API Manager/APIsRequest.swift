//
//  APIsRequest.swift
//  example
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit

// MARK: - Signup
struct SignupRequest: Codable {
    let username, email, password: String
    let role: [String]
    let firstName, lastName: String
    let phoneNo: Int
}

extension SignupRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: SignUp) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: ""),
            url:Constant.URL,
            endPoint: Constant.URL_SIGNUP,
            requestType: .POST,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}


struct Token {
    let accessToken: String
}

// MARK: - SigninRequest
struct SigninRequest: Codable {
    let username, password: String
    
}
extension SigninRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: Signin) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: ""),
            url:Constant.URL,
            endPoint: Constant.URL_SIGNIN,
            requestType: .POST,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

// MARK: - CreateGroupRequest
struct CreateGroupRequest: Codable {
    let groupName, groupDescription: String
}

extension CreateGroupRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: CreateGroup) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_CREATE,
            requestType: .POST,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}


// MARK: - InviteUsersRequest
struct InviteUsersRequest: Codable {
    let groupName, groupDescription: String
    let users: [String]
}

extension InviteUsersRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: JoinGroup) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_INVITE,
            requestType: .POST,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

// MARK: - ProfileRequest
struct ProfileUpdateRequest: Codable {
    let username, email, firstName, lastName: String
    let phoneNo: Int
}

extension ProfileUpdateRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: User) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_USER_INFO,
            requestType: .PUT,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

// MARK: - UserProfile
struct UserInfoRequest: Codable {
}
extension UserInfoRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: User) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_USER_INFO,
            requestType: .GET,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}


// MARK: - JoinGroupRequest
struct JoinGroupRequest: Codable {
    let groupId: Int
}

extension JoinGroupRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: JoinGroup) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_JOIN,
            requestType: .POST,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

// MARK: - JoinGroupRequest
struct GroupInfoRequest: Codable {
}

extension GroupInfoRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: GroupInfo) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_INFO,
            requestType: .GET,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

// MARK: - TaskRequest
struct TaskRequest: Codable {
    let taskName, userInCharge, taskDescription, completionDate: String
    let isTaskComplete,isTaskUpForSwap:Bool
}

extension TaskRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: Task) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken:Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_USER_TASK_CREATE,
            requestType: .POST,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

struct ReportElements:Codable{
    let title,value:String
    let short:Bool
}

struct ReportBugRequest:Codable {
    let fields:[ReportElements]
}

extension ReportBugRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: String) -> Void),
        onFailure failureHandler: @escaping ((_: String?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken:""),
            url:Constant.URL_SLACK,
            endPoint: Constant.URL_USER_REPORT_BUG,
            requestType: .POST,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

struct GroupTaskInfoRequest:Codable{
    
}
extension GroupTaskInfoRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: [Task]) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_TASK_INFO,
            requestType: .GET,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

struct GroupItemInfoRequest:Codable{
    
}
extension GroupItemInfoRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: [Item]) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_ITEM_INFO,
            requestType: .GET,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

struct TaskDeleteRequest:Codable{
    let id:Int
}
extension TaskDeleteRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: MessaegeResponse) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_USER_TASK_DELETE + "\(self.id)",
            requestType: .DELETE,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

struct ItemDeleteRequest:Codable{
    let id:String
}

extension ItemDeleteRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: MessaegeResponse) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_ITEM_DELETE + self.id,
            requestType: .DELETE,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

struct TaskUpdateRequest:Codable{
    let id,taskName, userInCharge, taskDescription, completionDate: String
    let isTaskComplete,isTaskUpForSwap:Bool
}
extension TaskUpdateRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: Task) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_USER_TASK_UPDATE + self.id,
            requestType: .PUT,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

struct ItemUpdateRequest:Codable{
    let id,taskName, taskDescription, completionDate, itemName,boughtBy,purchasedOnDate: String
    let isTaskComplete:Bool
    let itemPrice:Double
    let sharedUsers:[String]
}
extension ItemUpdateRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: Item) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_ITEM_UPDATE + self.id,
            requestType: .PUT,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

// MARK: - ItemRequest
struct ItemRequest: Codable {
    let taskName, taskDescription, completionDate, itemName: String
}

extension ItemRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: Item) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_ITEM_CREATE,
            requestType: .POST,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

// MARK: - UpdateGroupInfoRequest
struct UpdateGroupInfoRequest: Codable {
    let groupName, groupDescription: String
}

extension UpdateGroupInfoRequest {
    func dispatch(
        onSuccess successHandler: @escaping ((_: UpdateGroup) -> Void),
        onFailure failureHandler: @escaping ((_: ErrorResponse?, _: Error) -> Void) ) {
        APIManager.post(
            request: self,
            header: Token.init(accessToken: Singleton.shared.userCreds?.accessToken ?? ""),
            url:Constant.URL,
            endPoint: Constant.URL_GROUP_UPDATE,
            requestType: .PUT,
            onSuccess: successHandler,
            onError: failureHandler
        )
    }
}

// MARK: - APIError
enum APIError: Error {
    case invalidEndpoint
    case errorResponseDetected
    case noData
}


