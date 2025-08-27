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
        
        // MARK: - Handle header
        if let finalHeaders = headers{
            for (headerField, headerValue) in finalHeaders {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }else{
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // MARK: - Handle body
        do {
            if let model = modelCodable {
                print("📦 Request Body Model: \(model)")
                request.httpBody = try JSONEncoder().encode(model)
            } else if let parameters = param {
                print("📦 Request Parameters: \(parameters)")
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }
        }catch {
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
                    res(objectData)
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
                                    let newViewController = LoginVC()
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
        
        let body: Parameters = [
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
    
    deinit{
        print("==> ✅ Deinit ApiManager.")
    }
}

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case noInternet
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError(statusCode: Int)
    case decodingError(Error)
    case requestError(Error)
    case tokenRefreshFailed
    
    var errorDescription: String? {
        switch self {
        case .noInternet: return "No internet connection"
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response from server"
        case .unauthorized: return "Authentication required"
        case .serverError(let code): return "Server error (code: \(code))"
        case .decodingError(let error): return "Failed to decode response: \(error.localizedDescription)"
        case .requestError(let error): return "Request failed: \(error.localizedDescription)"
        case .tokenRefreshFailed: return "Session expired. Please log in again."
        }
    }
}


// MARK: - API Manager
class ApiManagerAsyncAwait {
    static let shared = ApiManagerAsyncAwait()

    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private var refreshTask: Task<String, Error>?
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    // MARK: - Main Request Method
    func request<T: Codable>(
        endpoint: EndpointEnum,
        method: HTTPMethodEnum = .GET,
        parameters: Parameters? = nil,
        body: Encodable? = nil,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        // Check internet connection
        guard isConnectedToNetwork() else {
            throw NetworkError.noInternet
        }
        
        // Create request
        let request = try await createRequest(
            endpoint: endpoint,
            method: method,
            parameters: parameters,
            body: body,
            queryItems: queryItems
        )
        
        // Execute request
        return try await executeRequest(request)
    }
    
    // MARK: - Request Creation
    private func createRequest(
        endpoint: EndpointEnum,
        method: HTTPMethodEnum,
        parameters: Parameters? = nil,
        body: Encodable? = nil,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> URLRequest {
        // Build URL
        var components = URLComponents(string: AppConfiguration.shared.apiBaseURL)
        components?.path += endpoint.rawValue
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = try await getHeaders()
        
        // Add body if present
        if let body = body {
            request.httpBody = try encoder.encode(body)
        } else if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
    
    // MARK: - Request Execution
    private func executeRequest<T: Codable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        
        // Log response for debugging
        await logResponse(request: request, data: data)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return try decoder.decode(T.self, from: data)
            
        case 401:
            return try await handleUnauthorizedResponse(request: request)
            
        case 404:
            throw NetworkError.invalidResponse
            
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    // MARK: - Token Handling
    private func getHeaders() async throws -> HTTPHeaders {
        var headers = defaultHeaders()
        
        // Add auth token if available
        if let token = try await getValidToken() {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    private func getValidToken() async throws -> String? {
        guard let token = UserDefaults.standard.string(forKey: AppConstants.token) else {
            return nil
        }
        
        // Here you could add token validation logic (expiry check)
        return token
    }
    
    private func refreshToken() async throws -> String {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        
        let task = Task<String, Error> {
            // defer delay
            defer { refreshTask = nil }
            
            let request = try await createRequest(
                endpoint: .refreshToken,
                method: .POST,
                parameters: [
                    "refresh": UserDefaults.standard.string(forKey: AppConstants.refreshToken) ?? ""
                ]
            )
            
            let response: LoginModel = try await executeRequest(request)
            
            // Save new tokens
            UserDefaults.standard.set(response.access, forKey: AppConstants.token)
            UserDefaults.standard.set(response.refresh, forKey: AppConstants.refreshToken)
            
            return response.access
        }
        
        refreshTask = task
        return try await task.value
    }
    
    // MARK: - Error Handling
    private func handleUnauthorizedResponse<T: Codable>(request: URLRequest) async throws -> T {
        do {
            // Try to refresh token
            let newToken = try await refreshToken()
            
            // Retry original request with new token
            var newRequest = request
            newRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
            
            return try await executeRequest(newRequest)
        } catch {
            // Token refresh failed, clear user data and show login
            await MainActor.run {
                UserDefaults.standard.removeObject(forKey: AppConstants.token)
                UserDefaults.standard.removeObject(forKey: AppConstants.refreshToken)
                SceneDelegate.shared.changeRootViewController(to: LoginVC())
            }
            throw NetworkError.tokenRefreshFailed
        }
    }
    
    // MARK: - Utilities
    private func defaultHeaders() -> HTTPHeaders {
        let lang = LanguageManager.shared.getCurrentLanguage().rawValue
        
        return [
            "Content-Type": "application/json",
            "Authorize": "4ee0d884634c0b04360c5d26060eb0dac61209c0db21d84aa9b315f1599e9a41",
            "Auth": "6213cbd30b40d782b27bcaf41f354fb8aa2353a9e59c66fba790febe9ab4cf44",
            "lang": lang
        ]
        
    }
    
    private func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) else {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
    
    private func logResponse(request: URLRequest, data: Data) async {

        let urlString = request.url?.absoluteString ?? "Unknown URL"
        let headers = request.allHTTPHeaderFields ?? [:]
        let body = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? "None"
        let responseString = String(data: data, encoding: .utf8) ?? "Invalid response data"
        
        let logMessage = """
        \n\n
        ✅------------------- API Request -------------------
        URL: \(urlString)
        Headers: \(headers)
        Body: \(body)
        ✅------------------- Response ----------------------
        \(responseString)
        \n
        -----------------------------------------------------
        """
        
        print(logMessage)

    }
}

