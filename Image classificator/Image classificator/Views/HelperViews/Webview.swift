//
//  Webview.swift
//  Image classificator
//
//  Created by vojta on 13.03.2021.
//

import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    
    var url = "https://cs.wikipedia.org/wiki/Jablko"
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.load(URLRequest(url: URL(string: url)!))
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
   
  
}

