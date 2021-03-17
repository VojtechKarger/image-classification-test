//
//  Web view.swift
//  pamatky classifier
//
//  Created by vojta on 16.03.2021.
//

import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        let webView = WKWebView()
        
        let Url = URL(string: url)!
        webView.load(URLRequest(url: Url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }

}


