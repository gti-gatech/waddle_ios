//
//  TermAndConditionsViewController.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 06/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import WebKit

enum WebviewType {
    case terms
    case privacy
    case tips
    case about
}
class TermAndConditionsVC: UIViewController {
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var viewSuperWeb: UIView!
    var isFromSideMenu = false
    var webViewType:WebviewType = WebviewType.terms
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 22/255, green: 32/255, blue: 61/255, alpha: 1)
        CommonFunctions.setLeftBarButtonItemWith(image: #imageLiteral(resourceName: "back"), action: #selector(backButtonAction), view: self)
        self.setupUI()
        webView.isOpaque = false
        webView.scrollView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
    }
    func setupUI() {
        var strUrl = ""
        switch webViewType {
        case .privacy:
            strUrl = ServiceAPI.api_privacy.urlString()
        case .terms:
            strUrl = ServiceAPI.api_terms.urlString()
        case .about:
            strUrl = "http://34.209.64.150/pdfs/About%20us.pdf"//ServiceAPI.api_about.urlString()
        case .tips:
            strUrl = "http://34.209.64.150/pdfs/Tips.pdf"// ServiceAPI.api_tips.urlString()
        }
        switch webViewType {
        case .terms:
            self.title = "Terms & Conditions"
        case .privacy:
            self.title = "Privacy Policy"
        case .tips:
            self.title = "Tips"
        case .about:
            self.title = "About"
        }
        
        let myURL = URL(string: strUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.navigationDelegate = self
        CommonFunctions.showHUD(controller: self)
        self.Activity.startAnimating()
        self.view.backgroundColor = .white
        if isFromSideMenu{
            self.viewSuperWeb.isHidden = true
            self.btnAgree.isHidden = true
            self.view.addSubview(webView)
            NSLayoutConstraint.activate([
                webView.topAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                webView.leftAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                webView.bottomAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                webView.rightAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
            ])
        }else{
            self.viewSuperWeb.addSubview(webView)
            NSLayoutConstraint.activate([
                webView.topAnchor
                    .constraint(equalTo: viewSuperWeb.topAnchor),
                webView.leftAnchor
                    .constraint(equalTo: viewSuperWeb.leftAnchor),
                webView.bottomAnchor
                    .constraint(equalTo: viewSuperWeb.bottomAnchor),
                webView.rightAnchor
                    .constraint(equalTo: viewSuperWeb.rightAnchor)
            ])
        }
        self.view.bringSubviewToFront(self.Activity)
        
    }
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}
extension TermAndConditionsVC: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CommonFunctions.hideHUD(controller: self)
        Activity.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CommonFunctions.hideHUD(controller: self)
        Activity.stopAnimating()
    }
    
}
