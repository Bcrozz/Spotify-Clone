//
//  AuthViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import UIKit
import WebKit
import Moya

class AuthViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "log in with Spotify"
        webView.navigationDelegate = self
        loadSignInWebView()
    }
    

    private func loadSignInWebView(){
        AuthManager.shared.authProvider.request(.reqestAuthorize()) { [weak self] result in

            switch result {
            case let .success(response):
                self?.webView.load(response.request!)
                
            case let .failure(error):
                print(error.localizedDescription)
            }

        }
    }

    
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"
        })?.value else {
            return
        }
        
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
        
        
    }
    
}

extension AuthViewController: PluginType {

    

}
