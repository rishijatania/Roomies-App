//
//  APIHandler.swift
//  example
//
//  Created by Rishi Jatania on 4/21/20.
//  Copyright © 2020 Rishi Jatania. All rights reserved.
//

import UIKit


enum RequestType : String
{
    case POST = "POST"
    case GET = "GET"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

struct APIManager {
    
    public static func post<R: Codable,T: Codable, E: Codable>(
        request: R,
        header: Token,
        url:String,
        endPoint: String,
        requestType: RequestType,
        onSuccess: @escaping ((_: T) -> Void),
        onError: @escaping ((_: E?, _: Error) -> Void))
    {
        if(!Singleton.shared.checkfornetwork()){
            return
        }
        guard var endpointRequest = self.urlRequest(from: endPoint,for:url) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        
        if !header.accessToken.isEmpty {
            let auth = "Bearer \(header.accessToken)"
            endpointRequest.addValue("\(auth)", forHTTPHeaderField: "Authorization")
        }
        endpointRequest.httpMethod = requestType.rawValue
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requestType == .POST || requestType == .PUT
        {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                endpointRequest.httpBody = try encoder.encode(request)
            } catch {
                onError(nil, error)
                return
            }
        }
        
        URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                }
        }).resume()
    }
    
    public static func processResponse<T: Codable, E: Codable>(
        _ dataOrNil: Data?,
        _ urlResponseOrNil: URLResponse?,
        _ errorOrNil: Error?,
        onSuccess: ((_: T) -> Void),
        onError: ((_: E?, _: Error) -> Void)) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let data = dataOrNil {
            if Int((urlResponseOrNil as! HTTPURLResponse).statusCode)<400 {
                do {
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    onSuccess(decodedResponse)
                } catch {
                    let originalError = error
                    onError(nil, originalError)
                }
            } else {
                do {
                    let errorResponse = try JSONDecoder().decode(E.self, from: data)
                    onError(errorResponse, APIError.errorResponseDetected)
                } catch {
                    let originalError = error
                    onError(nil, originalError)
                }
            }
        } else {
            onError(nil, errorOrNil ?? APIError.noData)
        }
    }
    
    public static func urlRequest(from endpoint: String,for url:String) -> URLRequest? {
        guard let endpointUrl = URL(string: "\(url)\(endpoint)") else {
            return nil
        }
        
        var endpointRequest = URLRequest(url: endpointUrl)
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return endpointRequest
    }
}
