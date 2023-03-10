//
//  SignUpWebViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 20.01.2023.
//

import UIKit
import WebKit

class SignUpWebViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = WKWebView()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.setProgress(0, animated: true)
        progressView.trackTintColor = .lightGray
        progressView.tintColor = .blue
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.backgroundColor = .systemBackground
        webView.backgroundColor = .systemBackground
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.addSubview(spinner)
        webView.addSubview(progressView)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadHomePage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    // MARK: - Home page
    private func loadHomePage() {
        let homePage = "https://www.themoviedb.org/signup"
        guard let url =  URL(string: homePage) else {
            navigationController?.dismiss(animated: true)
            return
        }
        let request = URLRequest(url: url)
        
        DispatchQueue.main.async {
            self.webView.load(request)
            
            print(self.webView.isLoading)
        }
    }
}

// MARK: - Constraints
extension SignUpWebViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 30),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: -30),
            progressView.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: webView.centerYAnchor, constant: -40)
        ])
    }
}

// MARK: - Delegate
extension SignUpWebViewController: WKUIDelegate, WKNavigationDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            
            self.progressView.progress = Float(webView.estimatedProgress)
            if webView.estimatedProgress == 1 {
                self.progressView.isHidden = true
                self.spinner.stopAnimating()
            }
        }
    }
}
