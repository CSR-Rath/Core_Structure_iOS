//
//  DisplayWebController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/12/24.
//

import UIKit


import UIKit
import WebKit

class DisplayWebController: UIViewController, WKNavigationDelegate, UIGestureRecognizerDelegate {
    
    var callBackKHQRTapped:(() -> ())?
    var webView: WKWebView!
    var khQRlink: String? = "https://web.whatsapp.com/"
    var pluse = 0
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.backgroundColor = .red
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.addSubview(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: webView.topAnchor),
            topView.widthAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 1.0),
            topView.heightAnchor.constraint(equalToConstant: 60)
        ])
 

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async { [self] in
            let url = URL(string: "\(khQRlink ?? "")")!
            self.webView.load(URLRequest(url: url))
            self.webView.allowsBackForwardNavigationGestures = false
            
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    @objc func didClickedBack() {
        callBackKHQRTapped?()
        self.navigationController?.popViewController(animated: true)
        print("Back Navigation KHQR")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
       
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            print("link:\(navigationAction.request)")
            DispatchQueue.main.async {
               
                print("request:\(navigationAction.request.url!)")
            }
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
//    https://checkout-sandbox.payway.com.kh/www.staticmerchanturl.com/Success
        
        print("path:\(url.pathComponents)")

        if url.pathComponents.last?.contains("Success") ?? false {
            navigationController?.popViewController(animated: true)
            callBackKHQRTapped?()
        }
        
        print("url:\(url)")
        decisionHandler(WKNavigationActionPolicy.allow)
    }

}

