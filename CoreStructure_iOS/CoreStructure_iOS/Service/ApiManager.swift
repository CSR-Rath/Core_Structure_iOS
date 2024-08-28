//
//  ApiManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import Foundation
import SystemConfiguration
import UIKit

enum HTTPMethod: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

public typealias Parameters = [String: Any]
//public typealias Success = (_ response: Data) -> Void
public typealias Complete = () -> Void
public typealias HTTPHeaders = [String: String]


class ApiManager {
    
    // Get the default headers
    static func getHeader() -> HTTPHeaders {
        let token = ""
        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
            "Authorize": "4ee0d884634c0b04360c5d26060eb0dac61209c0db21d84aa9b315f1599e9a41",
            "Auth": "6213cbd30b40d782b27bcaf41f354fb8aa2353a9e59c66fba790febe9ab4cf44",
            "lang": "en"
        ]
    }
    
    static func apiConnection<T: Codable>(url: String,
                                          method: HTTPMethod,
                                          param: Parameters? = nil,
                                          modelCodable:Encodable? = nil,
                                          headers: HTTPHeaders? = ApiManager.getHeader(),
                                          res: @escaping (T) -> ()) {
        
        let stringUrl = URL(string: url)
        let request = NSMutableURLRequest()
        request.timeoutInterval = 60 // set duration for NSURLErrorTimedOut
        request.url = stringUrl
        request.httpMethod = method.rawValue
        
        // Set Content-Type header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add additional headers if provided
        if let headers = headers {
            for (headerField, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        // Add parameters
        if modelCodable != nil {
            
            do {//swift object model into json data
                request.httpBody = try! JSONEncoder().encode(modelCodable!)
            }
            
        }else if let param = param {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // Check internet connection
        if !Reachability.isConnectedToNetwork() {
            print("Internet is't connected. Please check your internet.")
            Loading.shared.hideLoading()
            return
        }
        
        let newRequest = request as URLRequest
        // Send the request
        let task = URLSession.shared.dataTask(with: newRequest, completionHandler: { (data, response, error) in
            
            if let error = error as? NSError {
                switch error.code {
                case NSURLErrorTimedOut:
                    // Handle timeout error
                    print("error ===> NSURLErrorTimedOut")
                    
                    DispatchQueue.main.async {
                        contronller.alerMessage(message: "NSURLErrorTimedOut") { isTrue in
                            contronller.dismiss(animated: true)
                        }
                        Loading.shared.hideLoading()
                    }
                    
                case NSURLErrorCannotConnectToHost:
                    // Handle "Could not connect to the server" error
                    print("error ===> NSURLErrorCannotConnectToHost")
                    
                    DispatchQueue.main.async {
                        contronller.alerMessage(message: "NSURLErrorCannotConnectToHost") { isTrue in
                            contronller.dismiss(animated: true)
                        }
                        Loading.shared.hideLoading()
                    }
                    
                default:
                    
                    print("error ===>  \(error)")
                    
                    DispatchQueue.main.async {
                        contronller.alerMessage(message: "\(error)") { isTrue in
                            contronller.dismiss(animated: true)
                        }
                        Loading.shared.hideLoading()
                    }
                    
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300: // 200 - 299
                    print("statusCode == 2xx")
                    Utilize.shared.debuggerResult(urlRequest: newRequest, data: data, error: false)
                    Utilize.shared.validateModel(model: T.self, data: data) { objectData in
                        print("====> Validate model success")
                        res(objectData)
                    }
                case 401:
                    print("statusCode == 401")
                    // Handle 401 Unauthorized response
                    // self.refreshToken { data in
                    //     let header = ["Authorization": "Bearer \(data.results?.token ?? "")"]
                    //     self.apiConnection(url: url, method: method, param: param, headers: header, res: res)
                    // }
                default:
                    Loading.shared.hideLoading()
                    Utilize.shared.debuggerResult(urlRequest: newRequest, data: data, error: true)
                    print("error_code: \(httpResponse.statusCode)")
                    
                    
                }
            }
            
        })
        task.resume()
    }
}




