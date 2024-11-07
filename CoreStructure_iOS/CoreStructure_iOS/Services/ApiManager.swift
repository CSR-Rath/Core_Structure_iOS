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

public typealias Parameters = [String: Any] //  httpBody right?
public typealias Success = (_ response: Data) -> Void
public typealias Complete = () -> Void
public typealias HTTPHeaders = [String: String]

// MARK: - Header request
//private let getHeader : HTTPHeaders = [
//    "Authorization": "Bearer \(UserDefaults.standard.value(forKey: AppConstants.language) ?? "")",
//    "Content-Type": "application/json",
//    "Authorize": "4ee0d884634c0b04360c5d26060eb0dac61209c0db21d84aa9b315f1599e9a41",
//    "Auth": "6213cbd30b40d782b27bcaf41f354fb8aa2353a9e59c66fba790febe9ab4cf44",
//    "lang": "\(UserDefaults.standard.value(forKey: AppConstants.language) ?? "")"
//]

func getHeader() -> HTTPHeaders{
    
    let token = UserDefaults.standard.value(forKey: AppConstants.token) ?? ""
    let lang = UserDefaults.standard.value(forKey: AppConstants.language) ?? "en"
    
    
    return  [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
            "Authorize": "4ee0d884634c0b04360c5d26060eb0dac61209c0db21d84aa9b315f1599e9a41",
            "Auth": "6213cbd30b40d782b27bcaf41f354fb8aa2353a9e59c66fba790febe9ab4cf44",
            "lang": "\(lang)"
        ]
}


class ApiManager {
    
   static let shared = ApiManager()

    
    func apiConnection<T: Codable>(url: String,
                                   method: HTTPMethod = .GET,
                                   param: Parameters? = nil,
                                   modelCodable: Encodable? = nil,
                                   headers: HTTPHeaders? = getHeader(),
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
        
        
        //MARK: Check internet connection
        if isConnectedToNetwork() {
            AlertMessage.shared.alertError(status: .internet)
        }
        
        let newRequest = request as URLRequest
        //MARK: Send the request
        let task = URLSession.shared.dataTask(with: newRequest, completionHandler: { (data, response, error) in
            
            //MARK: Handle error
            if let error = error as NSError? {
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
                    AlertMessage.shared.alertError(message: "\(error.localizedDescription)",
                                                  status: .requestError)
                }
                return
            }
            
            //MARK: handle httpResponse statusCode
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300: // 200 - 299
                    DebuggerRespose.shared.debuggerResult(urlRequest: newRequest,
                                                          data: data, error: false)
                    
                    DebuggerRespose.shared.validateModel(model: T.self,
                                                         data: data) { objectData in
                        print("====> Validate model success")
                        res(objectData)
                    }
                    
                case 400:
                    AlertMessage.shared.alertError(status: .code400)
                case 401:
                    AlertMessage.shared.alertError(status: .code401)
//                     self.refreshToken { data in
//                         let header = ["Authorization": "Bearer \(data.results?.token ?? "")"]
//                         self.apiConnection(url: url,
//                                            method: method,
//                                            param: param,
//                                            headers: header,
//                                            res: res)
//                     }
                case 404:
                    AlertMessage.shared.alertError(status: .code404)
                case 500:
                    AlertMessage.shared.alertError(status: .code500)
                default:

                    AlertMessage.shared.alertError(message: "\(httpResponse.statusCode)",
                                                  status: .none)
                    
                    DebuggerRespose.shared.debuggerResult(urlRequest: newRequest,
                                                  data: data, error: true)
                }
            }
        })
        task.resume()
    }
}




// MARK: - Check internet connection
func isConnectedToNetwork() -> Bool {

   var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
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
