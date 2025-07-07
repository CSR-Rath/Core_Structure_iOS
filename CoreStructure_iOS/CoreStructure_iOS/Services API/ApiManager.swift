//
//  ApiManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import SystemConfiguration

enum HTTPMethodEnum: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]


var isRefreshToken: Bool = false

struct APIResponseModel:Codable {
    var response: ResponseModel
}

struct ResponseModel:Codable {
    var code: Int
    var message: String
}

class ApiManager {
    
    static let shared = ApiManager()
    private var currentTask: URLSessionDataTask?
    
    func cancelRequest() {
        currentTask?.cancel()
        currentTask = nil
        print("API request cancelled")
    }
    
    func apiConnection<T: Codable>(
        url: EndpointEnum,
        method: HTTPMethodEnum = .GET,
        param: Parameters? = nil,
        modelCodable: Encodable? = nil,
        headers: HTTPHeaders? = getHeader(),
        query: String = "",
        res: @escaping (T) -> ()){
            
            if !isConnectedToNetwork(){
                AlertMessage.shared.alertError(status: .internet)
                return
            }
            
            let stringURL = AppConfiguration.shared.apiBaseURL + url.rawValue + query
            
            guard let stringUrl = URL(string: stringURL) else {
                print("==> Invalid URL: \(stringURL)")
                return
            }
            
            var request = URLRequest(url: stringUrl)
            request.timeoutInterval = 60
            request.httpMethod = method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let finalHeaders = headers {
                for (headerField, headerValue) in finalHeaders {
                    request.setValue(headerValue, forHTTPHeaderField: headerField)
                }
            }
            
            do {
                if let modelCodable = modelCodable {
                    request.httpBody = try JSONEncoder().encode(modelCodable)
                } else if let param = param {
                    request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
                }
            }
            catch {
                print("Error setting HTTP body: \(error.localizedDescription)")
                return
            }
            
            // Store the task
            currentTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error as NSError? {
                    handleError(error: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else { return }
                
                
                
                
                switch httpResponse.statusCode {
                case 200..<300:
                    
                    guard let data = data else { return }
                    /// Show APIResponse
                    DebuggerRespose.shared.debuggerResult(urlRequest: request, data: data, error: false)
                    
                    /// Handle respone in httpResponse.statusCode 200
                    do {
                        /// Try decoding to generic wrapper
                        let apiResponse = try JSONDecoder().decode(APIResponseModel.self, from: data)
                        
                        if apiResponse.response.code == 200 {
                            
                            DebuggerRespose.shared.validateModel(model: T.self, data: data) { objectData in
                                res(objectData)
                            }
                            
                        }
                        else if apiResponse.response.code == 500 {
                            
                            AlertMessage.shared.alertError()
                            
                        }
                        else{
                            
                            AlertMessage.shared.alertError(message: apiResponse.response.message)
                            
                        }
                        
                    }
                    catch {
                        print("Decoding apiResponse is failed:", error)
                    }
                    
                case 401:
                    
                    if isRefreshToken{
                        
                        UserDefaults.standard.set("", forKey: AppConstants.token)
                        UserDefaults.standard.set("", forKey: AppConstants.refreshToken)
                        
                        print("🔄 Token refreshed. Retrying original request...")
                        
                        self.apiConnection(url: url,
                                           method: method,
                                           param: param,
                                           modelCodable: modelCodable,
                                           headers: getHeader(),
                                           query: query) { response in
                            res(response)
                        }
                        
                    } else {
                        
                        print("❌ Go to log out!")
                    }
                    
                    print("🔒 Unauthorized")
                    
                default:
                    
                    print("⚠️ Other status code: \(httpResponse.statusCode)")
                    //                    print("❌ Bad Request") //400
                    //                    print("❌ Not Found") //404
                    //                    print("💥 Server Error") // 500
                    
                }
                
                
                
            }
            currentTask?.resume()
        }
}


func getHeader() -> HTTPHeaders {
    
    let token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4MjR8R0MtODU1ODE4NTYwOTB8dHJ1ZXxVU0VSX0NVU19HRU5FUkFMIiwiaWF0IjoxNzUwMjk3NDY4LCJleHAiOjE3NTI4ODQ2Njh9.0hLTNc3EQwkAQoY2paOdMcYAPCN3EXU2ykcjauqONXV-a4-Go1ulJpRX70jiqRBKmVsZZJgHdJ2Bs4Rwv5Zrsw"//UserDefaults.standard.string(forKey: AppConstants.token) ?? ""
    let lang = LanguageManager.shared.getCurrentLanguage().rawValue
    
    return [
        "Authorization": "Bearer \(token)",
        "Content-Type": "application/json",
        "Authorize": "4ee0d884634c0b04360c5d26060eb0dac61209c0db21d84aa9b315f1599e9a41",
        "Auth": "6213cbd30b40d782b27bcaf41f354fb8aa2353a9e59c66fba790febe9ab4cf44",
        "lang": lang
    ]
}

private func handleError(error: NSError) {
    print("error ==> \(error)")
    switch error.code {
    case NSURLErrorTimedOut:
        AlertMessage.shared.alertError()
    case NSURLErrorCannotConnectToHost:
        AlertMessage.shared.alertError()
    case NSURLErrorNotConnectedToInternet:
        AlertMessage.shared.alertError()
    case NSURLErrorBadURL:
        AlertMessage.shared.alertError()
    default:
        AlertMessage.shared.alertError()
    }
}

private func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in(sin_len: 0,
                                  sin_family: 0,
                                  sin_port: 0,
                                  sin_addr: in_addr(s_addr: 0),
                                  sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
    // Working for Cellular and WIFI
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (isReachable && !needsConnection)
    
    return ret
}

private func refreshToken(success: @escaping () -> Void) {
    
}

func query(page: Int? = nil,
           size: Int? = nil,
           query: String? = nil,
           startDate: String? = nil,
           endDate: String? = nil,
           another: String? = nil
) -> String {
    
    var components: [String] = []
    
    
    if let page = page{
        components.append("page=\(page)")
    }
    
    if let size = size{
        components.append("query=\(size)")
    }
    
    // Prevent issues with spaces or special characters in the query
    if let query = query?.trimmingCharacters(in: .whitespacesAndNewlines),
       !query.isEmpty,
       let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        components.append("query=\(encodedQuery)")
    }
    
    // Prevent issues with spaces or special characters in the query
    if let startDate = startDate?.trimmingCharacters(in: .whitespacesAndNewlines),
       !startDate.isEmpty,
       let encodedQuery = startDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        components.append("startDate=\(encodedQuery)")
    }
    
    // Prevent issues with spaces or special characters in the query
    if let endDate = endDate?.trimmingCharacters(in: .whitespacesAndNewlines),
       !endDate.isEmpty,
       let encodedQuery = endDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        components.append("endDate=\(encodedQuery)")
    }
    
    // Prevent issues with spaces or special characters in the query
    if let another = another?.trimmingCharacters(in: .whitespacesAndNewlines),
       !another.isEmpty,
       let encodedQuery = another.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        components.append("another=\(encodedQuery)")
    }
    
    return "?\(components.joined(separator: "&"))"
}


