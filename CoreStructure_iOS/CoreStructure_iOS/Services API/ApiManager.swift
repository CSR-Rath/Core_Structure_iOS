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

// MARK: - Token Model
struct RefreshTokenResponse: Codable {
    var results: RefreshTokenResults?
    var response: APIResponseStatus?
}

struct APIResponseStatus: Codable {
    var status: Int?
    var message: String?
}

struct RefreshTokenResults: Codable {
    var token: String?
    var refreshToken: String?
    var expired: Int?
}

//
//// MARK: - Header
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
//
//// MARK: - Reachability Check
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
//
//// MARK: - Error Handler
private func handleError(error: NSError) {
    print("error ==> \(error)")
    AlertMessage.shared.alertError()
}

class ApiManager {
    
    static let shared = ApiManager()
    private var currentTask: URLSessionDataTask?
    
    private let lock = NSLock()
    private var isRefreshingToken = false
    private var pendingRequests: [() -> Void] = []
    
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
        
        // Always get fresh headers
        let finalHeaders = headers ?? getHeader()
        for (headerField, headerValue) in finalHeaders {
            request.setValue(headerValue, forHTTPHeaderField: headerField)
        }

        do {
            if let model = modelCodable {
                request.httpBody = try JSONEncoder().encode(model)
            } else if let param = param {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
            }
        } catch {
            print("⚠️ Error setting HTTP body: \(error.localizedDescription)")
            return
        }

        currentTask = URLSession.shared.dataTask(with: request) { data, response, error in
            let duration = Date().timeIntervalSince(startTime)
            
            if let error = error as NSError? {
                AlertMessage.shared.alertError(title: "Error!", message: "Error requested", status: .timedOut)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            DebuggerRespose.shared.debuggerResult(urlRequest: request,
                                                data: data,
                                                error: false)

            switch httpResponse.statusCode {
            case 200..<300:
                print("✅ Request succeeded in \(duration) seconds: \(url)")
                
                guard let data = data else { return }
              
                DebuggerRespose.shared.validateModel(model: T.self, data: data) { objectData in
                    res(objectData)
                }
                
            case 401:
                print("🔒 Unauthorized – preparing to refresh token")
                
                self.lock.lock()
                // Add the request to pending requests
                self.pendingRequests.append { [weak self] in
                    self?.apiConnection(
                        url: url,
                        method: method,
                        param: param,
                        modelCodable: modelCodable,
                        headers: getHeader(), // Use fresh headers
                        query: query,
                        res: res
                    )
                }
                
                // Only start refresh if not already refreshing
                if !self.isRefreshingToken {
                    self.isRefreshingToken = true
                    self.lock.unlock()
                    
                    print("🔄 Starting token refresh - pending requests: \(self.pendingRequests.count)")
                    
                    self.refreshTokenIfNeeded { success in
                        self.lock.lock()
                        let requests = self.pendingRequests
                        self.pendingRequests.removeAll()
                        self.isRefreshingToken = false
                        self.lock.unlock()
                        
                        if success {
                            print("🔄 Token refresh succeeded - retrying \(requests.count) requests")
                            requests.forEach { $0() }
                        } else {
                            print("❌ Token refresh failed")
                            AlertMessage.shared.alertError(title: "Message",
                                                         message: "Token refresh failed",
                                                         status: .code401)
                        }
                    }
                } else {
                    print("\n\n\n⏳ Token refresh already in progress - queuing request")
                    self.lock.unlock()
                }
                
            default:
                print("⚠️ HTTP Status Code: \(httpResponse.statusCode)")
                AlertMessage.shared.alertError()
            }
        }
        currentTask?.resume()
    }

    private func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        let refreshToken = UserDefaults.standard.string(forKey: AppConstants.refreshToken) ?? ""
        print("\n🔄 RefreshingToken: \(refreshToken)")
        
        let url = URL(string: AppConfiguration.shared.apiBaseURL + EndpointEnum.refreshToken.rawValue)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        print("request: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("❌ Token refresh failed – no response")
                completion(false)
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    let decoded = try JSONDecoder().decode(RefreshTokenResponse.self, from: data)
                    if decoded.response?.status == 200,
                       let newToken = decoded.results?.token,
                       let newRefreshToken = decoded.results?.refreshToken {
                        UserDefaults.standard.set(newToken, forKey: AppConstants.token)
                        UserDefaults.standard.set(newRefreshToken, forKey: AppConstants.refreshToken)
                        print("🔑 New tokens saved")
                        completion(true)
                    } else {
                        print("❌ Token refresh response invalid")
                        completion(false)
                    }
                } catch {
                    print("❌ Failed to decode token refresh response: \(error)")
                    completion(false)
                }
            } else {
                print("❌ Token refresh failed with status: \(httpResponse.statusCode)")
                completion(false)
            }
        }.resume()
    }
}
