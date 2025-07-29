//
//  ApiManager.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import SystemConfiguration

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

enum HTTPMethodEnum: String {
    case POST, GET, PUT, DELETE, PATCH
}

struct ResponseModel:Codable {
    var status: Int?
    var message: String?
}

struct LoginModel: Codable{
    let refresh: String // refresh_token
    let access: String // token
}

// MARK: - Header
func getHeader() -> HTTPHeaders {
    let token = UserDefaults.standard.string(forKey: AppConstants.token) ?? ""
    let lang = LanguageManager.shared.getCurrentLanguage().rawValue
    
    return [
        "Authorization": "Bearer \(token)",
        "Content-Type": "application/json",
        "Authorize": "4ee0d884634c0b04360c5d26060eb0dac61209c0db21d84aa9b315f1599e9a41",
        "Auth": "6213cbd30b40d782b27bcaf41f354fb8aa2353a9e59c66fba790febe9ab4cf44",
        "lang": lang
    ]
}

// MARK: - Reachability Check
private func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
}


class ApiManager {
    
    static let shared = ApiManager()
   
    private var currentTask: URLSessionDataTask?
    private var isRefreshingToken = false
    private var pendingRequests: [() -> Void] = []
    private let refreshQueue = DispatchQueue(label: "com.yourapp.tokenRefreshQueue")
    
    func apiConnection<T: Codable>(
        url: EndpointEnum,
        method: HTTPMethodEnum = .GET,
        param: Parameters? = nil,
        modelCodable: Encodable? = nil,
        headers: HTTPHeaders? = getHeader(),
        query: String = "",
        res: @escaping (T) -> Void
    ) {
        let startTime = Date()
        
        if !isConnectedToNetwork() {
            AlertMessage.shared.alertError(title: "No Internet", 
                                           message: "No Internet Connection. Please check your network and try again.")
            return
        }
        
        let stringURL = AppConfiguration.shared.apiBaseURL + url.rawValue + query
        guard let stringUrl = URL(string: stringURL) else {
            AlertMessage.shared.alertError(title: "Invalid URL",
                                           message: "Please try again later.")
            return
        }
        
        print("URL ==> \(stringURL)")
        
        var request = URLRequest(url: stringUrl)
        request.timeoutInterval = 60
        request.httpMethod = method.rawValue
        
        // Always get fresh headers
        if let finalHeaders = headers{
            for (headerField, headerValue) in finalHeaders {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        do {
            if let modelCodable {
                
                print("modelCodable: \(modelCodable)")
                request.httpBody = try JSONEncoder().encode(modelCodable)
            } else if let param {
                
                print("param: \(param)")
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
            }
        }
        catch {
            print("⚠️ Error setting HTTP body: \(error.localizedDescription)")
            return
        }
        
        currentTask = URLSession.shared.dataTask(with: request) { data, response, error in
            let duration = Date().timeIntervalSince(startTime)
            
            if let error = error as NSError? {
                
                print("❌ NSError:", error.localizedDescription)
                
                if error.domain == NSURLErrorDomain && error.code == NSURLErrorTimedOut {
                    AlertMessage.shared.alertError(title: "The request timed out",
                                                   message: "Please try again later.")
                }else{
                    AlertMessage.shared.alertError()
                }
                
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data else {
                AlertMessage.shared.alertError(title: "Network Error",
                                               message: "Failed to receive valid response from the server. Please try again.")
                return
            }
            
            DebuggerRespose.shared.debuggerResult(urlRequest: request,
                                                  data: data,
                                                  error: false)

            
            switch httpResponse.statusCode {
            case 200..<300:
                print("✅ Request succeeded in \(duration) seconds: \(url)")

                DebuggerRespose.shared.validateModel(model: T.self, data: data) { objectData in
                    Task { @MainActor in
                           res(objectData)
                       }
                }
                
            case 401:
                print("🔒 Unauthorized – preparing to refresh token\n\n\n")
                
                self.refreshQueue.sync {
                    self.pendingRequests.append {
                        self.apiConnection(url: url,
                                           method: method,
                                           param: param,
                                           modelCodable: modelCodable,
                                           headers: getHeader(),
                                           query: query,
                                           res: res)
                    }
                    
                    guard !self.isRefreshingToken else { return }
                    self.isRefreshingToken = true
                    
                    print("isRefreshingToken = \(self.isRefreshingToken)")
                    
                    self.refreshTokenIfNeeded { success in
                        self.refreshQueue.async {
                            self.isRefreshingToken = false
                            if success {
                                print("\n\n\n🔄 Retrying pending requests...")
                                self.pendingRequests.forEach { $0() }
                            } else {
                                print("❌ Token refresh failed. Clearing pending requests.")
                                DispatchQueue.main.async {
                                    let newViewController = LoginScreenVC()
                                    let navigationController = UINavigationController(rootViewController: newViewController)
                                    UIApplication.shared.windows.first?.rootViewController = navigationController
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                }
                            }
                            self.pendingRequests.removeAll()
                        }
                    }
                }
                
            default:
                print("⚠️ HTTP Status Code: \(httpResponse.statusCode)")
                AlertMessage.shared.alertError()
            }
        }
        currentTask?.resume()
    }
    
    private func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        
        let url = URL(string: AppConfiguration.shared.apiBaseURL + EndpointEnum.refreshToken.rawValue)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = HTTPMethodEnum.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let body: [String: Any] = [
            "refresh": UserDefaults.standard.string(forKey: AppConstants.refreshToken) ?? ""
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        print("URL 🔄: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, let data else {
                print("❌ Token refresh failed – no response")
                completion(false)
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            if httpResponse.statusCode == 200 {
                do {
                    let decoded = try JSONDecoder().decode(LoginModel.self, from: data)
                    
                    UserDefaults.standard.setValue(decoded.access, forKey: AppConstants.token)
                    UserDefaults.standard.setValue(decoded.refresh, forKey: AppConstants.refreshToken)
                    
                    print("🔑 New tokens saved")
                    completion(true)
                } catch {
                    print("❌ Failed to decode token refresh response: \(error)")
                    completion(false)
                }
            }
            else {
                print("❌ Token refresh failed with status: \(httpResponse.statusCode)")
                completion(false)
            }
            
        }.resume()
    }
}

