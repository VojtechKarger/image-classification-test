//
//  CameraButton.swift
//  pamatky classifier
//
//  Created by vojta on 16.03.2021.
//

import SwiftUI

struct CaptureButtonView: View {
    @State private var animationAmount: CGFloat = 1
    var body: some View {
        Image(systemName: "camera").font(.largeTitle)
            .padding(25)
            .background(Color.gray)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.gray)
                    .scaleEffect(animationAmount)
                    .opacity(Double(2 - animationAmount))
                    .animation(Animation.easeOut(duration: 1)
                        .repeatForever(autoreverses: false))
        )
            .onAppear
            {
                self.animationAmount = 2
        }
    }
}

struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        CaptureButtonView()
    }
}
