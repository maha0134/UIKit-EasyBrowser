//
//  WebViewController.swift
//  UIKit-Easy browser
//
//  Created by AKSHAY MAHAJAN on 2023-06-16.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
	var webView: WKWebView!
	var websites: [String]?
	var progressView: UIProgressView!
	
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
		
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		let back = UIBarButtonItem(barButtonSystemItem: .reply, target: webView, action: #selector(webView.goBack))
		let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
		
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)
		
		toolbarItems = [progressButton, spacer, back, forward, refresh]
		navigationController?.isToolbarHidden = false
		
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		if let websites {
			let url = URL(string: "https://" + websites[0])!
			webView.load(URLRequest(url: url))
		}
		webView.allowsBackForwardNavigationGestures = true
    }
	
	@objc func openTapped() {
		let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
		if let websites {
			for website in websites {
				ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
			}
			ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
			ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
			present(ac, animated: true)
		}
		
	}
	
	func openPage(action: UIAlertAction) {
		let url = URL(string: "https://" + action.title!)!
		webView.load(URLRequest(url: url))
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		
		if let host = url?.host, let websites {
			for website in websites {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}
			}
			let ac = UIAlertController(title: "Danger", message: "Sorry! Can't let you go.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
			ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
			present(ac, animated: true)
		}
		decisionHandler(.cancel)
	}

}
