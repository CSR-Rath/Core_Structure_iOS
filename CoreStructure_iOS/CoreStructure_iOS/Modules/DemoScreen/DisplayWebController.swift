//
//  DisplayWebController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 24/12/24.
//

import UIKit
import WebKit


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
