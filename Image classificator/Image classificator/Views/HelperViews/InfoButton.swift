//
//  InfoButton.swift
//  Image classificator
//
//  Created by vojta on 13.03.2021.
//

import SwiftUI

struct InfoButton: View {
    @State private var showingWeb = false
    
    var body: some View {
        NavigationLink(
            destination: Webview(),
            label: {
                Image(systemName: "info")
                    .foregroundColor(.black)
                    .padding(13)
                    .background(Color.white)
                    .clipShape(Circle())
            })
    }
}

struct InfoButton_Previews: PreviewProvider {
    static var previews: some View {
        InfoButton()
    }
}
