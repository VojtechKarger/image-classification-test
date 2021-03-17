//
//  FullWebView.swift
//  pamatky classifier
//
//  Created by vojta on 17.03.2021.
//

import SwiftUI

struct FullWebView: View {
    var url: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        GeometryReader { geo in
            ZStack{
                 
                VStack{
                    Rectangle()
                        .fill(Color.gray.opacity(0.8))
                        .frame(width: geo.size.width, height: 65, alignment: .center)

                    Webview(url: url)
                }.ignoresSafeArea(edges: .all)
                VStack{
                    HStack{
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .padding()
                                .foregroundColor(.black)
                        })
                        Spacer(minLength: 20)
                        Text("Wikipedia")
                        Spacer()
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct FullWebView_Previews: PreviewProvider {
    static let url = "https://www.wikipedia.org"
    static var previews: some View {
        FullWebView(url: url)
    }
}
