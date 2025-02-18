//
//  ApiManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import SystemConfiguration

enum HTTPMethod: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]


class ApiManager {
    
    static let shared = ApiManager()
    
    func apiConnection<T: Codable>(url: Endpoint,
                                   method: HTTPMethod = .GET,
                                   param: Parameters? = nil,
                                   modelCodable: Encodable? = nil,
                                   headers: HTTPHeaders? = getHeader(),
                                   query: String = "",
                                   res: @escaping (T) -> ()) {
        
        if !isConnectedToNetwork(){
            AlertMessage.shared.alertError(status: .internet)
            return
        }
        
        let stringUrl = URL(string: AppConfiguration.shared.apiBaseURL + url.rawValue + query)!
        var request = URLRequest(url: stringUrl)
        request.timeoutInterval = 60 // Set timeout duration
        request.httpMethod = method.rawValue
        
        print("stringUrl ===> \(stringUrl)")
        
        // Set Content-Type header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        if let finalHeaders = headers {
            // Add additional headers
            for (headerField, headerValue) in finalHeaders {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        do {
            // Add parameters
            if let modelCodable = modelCodable {
                
                request.httpBody = try JSONEncoder().encode(modelCodable) // Encodable to date
                print("modelCodable ==> \(modelCodable)")
                
            } else if let param = param {
                
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: []) // json to data
                print("param ==> \(param)")
                
            }
        }
        catch {
            print("Error setting HTTP body: \(error.localizedDescription)")
            return
        }
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle error
            if let error = error as NSError? {
                handleError(error)
                return
            }
            
            // Handle HTTP response
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            print("HTTP Code==> \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200..<300:
                
                DebuggerRespose.shared.debuggerResult(urlRequest: request, data: data, error: false)
                
                DebuggerRespose.shared.validateModel(model: T.self, data: data) { objectData in
                    res(objectData)
                    print("validateModel ==> Success")
                }
                
            case 401:
                
                // func refresh token
                refreshToken { // daka
                    
                    let newHeader = ["Authorization": "Bearer \("new token")"]
                    
                    // call self again
                    self.apiConnection(url: url, method: method, param: param, headers: newHeader, res: res)
                }
                
            default:
                
                AlertMessage.shared.alertError(message: "\(httpResponse.statusCode)", status: .none)
                
            }
        }
        task.resume()
    }
}

func query(page: Int, size: Int = 12, query: String? = nil) -> String {
    var components: [String] = [
        "page=\(page)",
        "size=\(size)"
    ]
    
    // Prevent issues with spaces or special characters in the query
    if let query = query?.trimmingCharacters(in: .whitespacesAndNewlines),
       !query.isEmpty,
       let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        components.append("query=\(encodedQuery)")
    }
    
    return "?\(components.joined(separator: "&"))"
}

private func getHeader() -> HTTPHeaders {
    
    let token = ""   //UserDefaults.standard.string(forKey: DefaultKeys.accessToken) ?? ""
    
    return [
        "Authorization": "Bearer \(token)",
        "Content-Type": "application/json",
        "Authorize": "4ee0d884634c0b04360c5d26060eb0dac61209c0db21d84aa9b315f1599e9a41",
        "Auth": "6213cbd30b40d782b27bcaf41f354fb8aa2353a9e59c66fba790febe9ab4cf44",
        "lang": "en"
    ]
}

func A(){
    ApiManager.shared.apiConnection(url: .guests,
                                    query: query(page: 0)
                                    
                                    
    ) { (res: User) in
        
    }
    
}

private func handleError(_ error: NSError) {
    print("error ==> \(error)")
    switch error.code {
    case NSURLErrorTimedOut:
        AlertMessage.shared.alertError(status: .timedOut)
    case NSURLErrorCannotConnectToHost:
        AlertMessage.shared.alertError(status: .cannotConnectToHost)
    case NSURLErrorNotConnectedToInternet:
        AlertMessage.shared.alertError(status: .notConnectedToInternet)
    case NSURLErrorBadURL:
        AlertMessage.shared.alertError(status: .badURL)
    default:
        AlertMessage.shared.alertError(message: "\(error.localizedDescription)", status: .requestError)
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
