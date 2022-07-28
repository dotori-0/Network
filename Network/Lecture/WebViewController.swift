//
//  WebViewController.swift
//  Network
//
//  Created by SC on 2022/07/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    var destinationURL: String = "https://www.apple.com"
    // App Transport Security Settings  // 검색해 보기
    // http X
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openWebPage(url: destinationURL)
        searchBar.delegate = self
        searchBar.text = destinationURL
    }
    

    func openWebPage(url: String) {
        // 유효한 URL 구조가 맞는지 판단하기 위해 guard let
        guard let url = URL(string: url) else {  // 없는 사이트이거나 휴먼에러 방지 (이상한 문자열만 확인해 준다)
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @IBAction func closeButtonClicked(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func goBackButtonClicked(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func goForwardButtonClicked(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}


extension WebViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)  // 옵셔널 바인딩 처리해 보기
    }
}
