//
//  DebuggerRespose.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit

class DebuggerRespose {
    
    static let shared = DebuggerRespose()
    
    func debuggerResult(urlRequest: URLRequest, data: Data?, error: Bool) {
        let url = urlRequest.url!
        let strUrl = url.absoluteString
        let allHeaders = urlRequest.allHTTPHeaderFields ?? [:]
        let body = urlRequest.httpBody.flatMap { String(decoding: $0, as: UTF8.self) }
        
        let result = """
        ⚡️⚡️⚡️⚡️ Headers: \(allHeaders)
        ⚡️⚡️⚡️⚡️ Request Body: \(String(describing: body))
        """
        print(result)
        
        let newData = data ?? Data()
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: newData, options: []) as? [String: Any] {
                formatDictionary(json: jsonObject, url: strUrl, error: error )
            } else if let arrayObject = try JSONSerialization.jsonObject(with: newData, options: []) as? [[String: Any]] {
                formatArrayOfDictionaries(json: arrayObject, url: strUrl, error: error )
            }
        } catch {
            print("Error parsing response: \(error.localizedDescription)")
        }
    }
    
    private func printerFormat(url: String, data: String, error: Bool) {
        let printer = """
        URL -->: \(url)
        Response Received -->: \(data)
        """
        
        if error {
            print("❌❌❌❌ \(printer) ❌❌❌❌")
        } else {
            print("✅✅✅✅ \(printer) ✅✅✅✅")
        }
    }
    
    private func formatArrayOfDictionaries(json: [[String: Any]],
                                           url: String,
                                           error: Bool) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return }
        
        printerFormat(url: url, data: jsonString, error: error)
    }
    
    private func formatDictionary(json: [String: Any],
                                  url: String,
                                  error: Bool) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return }
        
        printerFormat(url: url, data: jsonString, error: error)
    }
    
    func validateModel<T: Codable>(model: T.Type,
                                   data: Data?,
                                   fun: String = "",
                                   response: (T) -> Void) {
        do {
            if let newData = data {
                let json = try JSONDecoder().decode(T.self, from: newData)
                response(json)
            }
        } catch let DecodingError.typeMismatch(type, context) {
            DispatchQueue.main.async {
                print("Validator error: =>\(type), \(context.codingPath), \(context.debugDescription)")
                print("Validator error: =>\(context.showError(functionName: fun))")
                self.showAlert(message: context.showError(functionName: fun))
                Loading.shared.hideLoading()
            }
        } catch {
            DispatchQueue.main.async {
                print("Error decoding model: \(error.localizedDescription)")
                self.showAlert(message: error.localizedDescription)
                Loading.shared.hideLoading()
            }
        }
    }
    
    func showAlert(title: String = "", 
                   message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController?.present(alert, animated: true)
        }
    }
}

extension DecodingError.Context {
    func showError(functionName: String) -> String {
        let stringValue = self.codingPath.last?.stringValue ?? ""
        
        return String(format: "%@ \n %@ : %@", functionName, stringValue , self.debugDescription)
    }
}
