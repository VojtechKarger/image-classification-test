//
//  ContentView.swift
//  Image classificator
//
//  Created by vojta on 13.03.2021.
//

import SwiftUI
import CoreML

struct ContentView: View {
    // MARK: Variables
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingPicker = false
    @State private var classification: String?
    @State private var presentingAlert = false
    @State private var showingWeb = false

    
    //defining ML model
    let model: TestML = {
        do {
            let config = MLModelConfiguration()
            return try TestML(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create TestML")
        }
    }()
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack{
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(width: geo.size.width , height: geo.size.height, alignment: .center)
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(.bottom)
                    }
                    VStack {
                        Spacer()
                        Button(action: {
                            showingPicker = true
                            print("taped")
                        }, label: {
                            Text("Tap to select picture!")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Capsule())
                        }).padding()
                    }
                }
                
                .sheet(isPresented: $showingPicker, onDismiss: { loadImage() }, content: { ImagePicker(image: $inputImage) })
                .alert(isPresented: $presentingAlert, content: {
                    Alert(title: Text("It is...\(classification ?? "we don't know. ☹️\n Try it later!")"), dismissButton: .default(Text("OK")))
                })
                .navigationBarHidden(true)
            }
           
        }
    }
    
    
  // MARK: Functions
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        let imageToClassify = inputImage
        //resizing img. to corect size so ML model can classify it
        let resizedImg = imageToClassify.scalePreservingAspectRatio(targetSize: CGSize(width: 299, height: 299))
        //converting to buffer - needed for ML model
        guard let buffer = resizedImg.toCVPixelBuffer() else { print("neumí to konvertovat"); return }
        // just testing

        
        //classifying -- ignorovat nazvy faaaakt jsem nevedel jak to nazvat
        let classify = try? model.prediction(image: buffer)
        if let classifi = classify {
            classification = classifi.classLabel
            print(classifi.classLabel + "   hurááááááá funguje toooo!!!!!!")
            print(classifi.classLabelProbs)

        }else{
            print("tak uz faaaakt nevim 😭")
            classification = "nefunguje to 😡"
        }
        
        
        
        presentingAlert.toggle()
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
