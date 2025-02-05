//
//  DisplayWebController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/12/24.
//

import UIKit


import UIKit
import WebKit

let html: String =
"""

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Static Login Form</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }
    .login-container {
      background: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      width: 300px;
    }
    .login-container h2 {
      margin-bottom: 20px;
      text-align: center;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
    }
    .form-group input {
      width: 100%;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    .form-group button {
      width: 100%;
      padding: 10px;
      background-color: #007bff;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
    }
    .form-group button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>
  <div class="login-container">
    <h2>Login</h2>
    <form id="loginForm">
      <div class="form-group">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>
      </div>
      <div class="form-group">
        <button type="button" summite="validateLogin()">Login</button>
      </div>
    </form>
  </div>

  <script>
    // Static user data for testing
    const users = [
      { username: "admin", password: "123456" },
      { username: "user", password: "password" }
    ];

    function validateLogin() {
      const username = document.getElementById("username").value;
      const password = document.getElementById("password").value;

      // Check if the entered username and password match any user
      const user = users.find(user => user.username === username && user.password === password);

      if (user) {
        alert("Login successful!");
      } else {
        alert("Invalid username or password.");
      }
    }
  </script>
</body>
</html>

"""

class DisplayWebController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the WKWebView instance
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        self.view.addSubview(webView)

        // Load the HTML file into the WKWebView
        if let htmlPath = Bundle.main.path(forResource: "login", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
}



class LoginViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {

    var webView: WKWebView!

    // Simulated database of users
    let validUsers = [
        "admin": "123456",
        "user": "password"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentController = WKUserContentController()
        contentController.add(self, name: "loginHandler") // Register the message handler

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        webView = WKWebView(frame: self.view.frame, configuration: config)
        self.view.addSubview(webView)

        if let htmlPath = Bundle.main.path(forResource: "login", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }

    // Handle messages from JavaScript
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("message ==> \(message)")
        
        if message.name == "loginHandler", let credentials = message.body as? [String: String] {
            let username = credentials["username"] ?? ""
            let password = credentials["password"] ?? ""

            print("username ==> \(username)")
            print("password ==> \(password)")
            print("validUsers[username]" , validUsers[username])
            
            // Validate username and password
            if let validPassword = validUsers[username], validPassword == password {
                showAlert(title: "Success", message: "Login successful!")
            } else {
                showAlert(title: "Error", message: "Invalid username or password.")
            }
        }
    }

    // Helper method to display alerts
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}




//class DisplayWebController: UIViewController, WKNavigationDelegate, UIGestureRecognizerDelegate {
//    
//    var callBackKHQRTapped:(() -> ())?
//    var webView: WKWebView!
//    var khQRlink: String? =  html// "https://web.whatsapp.com/"
//    var pluse = 0
//    
//    lazy var topView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .yellow
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    override func loadView() {
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        webView.backgroundColor = .red
//        view = webView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        webView.addSubview(topView)
//        NSLayoutConstraint.activate([
//            topView.topAnchor.constraint(equalTo: webView.topAnchor),
//            topView.widthAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 1.0),
//            topView.heightAnchor.constraint(equalToConstant: 60)
//        ])
// 
//
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        DispatchQueue.main.async { [self] in
//            let url = URL(string: "\(khQRlink ?? "")")!
//            self.webView.load(URLRequest(url: url))
//            self.webView.allowsBackForwardNavigationGestures = false
//            
//            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//            
//        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.backgroundColor = .clear
//    }
//    
//    @objc func didClickedBack() {
//        callBackKHQRTapped?()
//        self.navigationController?.popViewController(animated: true)
//        print("Back Navigation KHQR")
//    }
//    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("didFinish")
//       
//    }
//    
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        print("didFail")
//        
//    }
//    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        
//        if navigationAction.navigationType == WKNavigationType.linkActivated {
//            print("link:\(navigationAction.request)")
//            DispatchQueue.main.async {
//               
//                print("request:\(navigationAction.request.url!)")
//            }
//            decisionHandler(WKNavigationActionPolicy.cancel)
//            return
//        }
//        
//        guard let url = navigationAction.request.url else {
//            decisionHandler(.allow)
//            return
//        }
//        
////    https://checkout-sandbox.payway.com.kh/www.staticmerchanturl.com/Success
//        
//        print("path:\(url.pathComponents)")
//
//        if url.pathComponents.last?.contains("Success") ?? false {
//            navigationController?.popViewController(animated: true)
//            callBackKHQRTapped?()
//        }
//        
//        print("url:\(url)")
//        decisionHandler(WKNavigationActionPolicy.allow)
//    }
//
//}



class ViewControllerTestingWeb: UIViewController, WKScriptMessageHandler {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a WKUserContentController
        let contentController = WKUserContentController()
        contentController.add(self, name: "loginHandler") // Add a message handler

        // Create WKWebView configuration
        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        // Initialize WKWebView
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        view.addSubview(webView)

        // Load HTML content
        let html: String = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Static Login Form</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              background-color: #f2f2f2;
              display: flex;
              justify-content: center;
              align-items: center;
              height: 100vh;
              margin: 0;
            }
            .login-container {
              background: #fff;
              padding: 20px;
              border-radius: 8px;
              box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
              width: 300px;
            }
            .login-container h2 {
              margin-bottom: 20px;
              text-align: center;
            }
            .form-group {
              margin-bottom: 15px;
            }
            .form-group label {
              display: block;
              margin-bottom: 5px;
              font-weight: bold;
            }
            .form-group input {
              width: 100%;
              padding: 10px;
              border: 1px solid #ccc;
              border-radius: 4px;
            }
            .form-group button {
              width: 100%;
              padding: 10px;
              background-color: #007bff;
              color: #fff;
              border: none;
              border-radius: 4px;
              cursor: pointer;
              font-size: 16px;
            }
            .form-group button:hover {
              background-color: #0056b3;
            }
          </style>
        </head>
        <body>
          <div class="login-container">
            <h2>Login</h2>
            <form id="loginForm">
              <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
              </div>
              <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
              </div>
              <div class="form-group">
                <button type="button" onclick="sendToApp()">Login</button>
              </div>
            </form>
          </div>
          <script>
            function sendToApp() {
                  const username = document.getElementById("username").value;
                  const password = document.getElementById("password").value;
        
                  // Send username and password to Swift
                  window.webkit.messageHandlers.loginHandler.postMessage({
                    username: username,
                    password: password
                  });
            }
          </script>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    


    // Handle messages from JavaScript
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "loginHandler", let credentials = message.body as? [String: String] {
            
            print("credentials ==> ",credentials)
            
            let username = credentials["username"] ?? ""
            let password = credentials["password"] ?? ""

            print("username ==>" , username)
            print("password ==>" , password)
            
            // Validate credentials
            if username == "admin" && password == "123456" {
                showAlert(title: "Success", message: "Login successful!")
            } else {
                showAlert(title: "Error", message: "Invalid username or password.")
            }
        }
    }

    // Helper function to show alerts
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
