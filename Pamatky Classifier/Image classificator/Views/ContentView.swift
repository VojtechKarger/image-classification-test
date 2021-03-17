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
    @State private var url = "https://cs.wikipedia.org/"
    @State private var loading = false

    @State private var classification: String?
    @State private var classificationWithLikness: String?
    
    @State private var presentingAlert = false
    @State var activeSheet: ActiveSheet?
    @State var lastSheet: ActiveSheet?
    
    enum ActiveSheet: Identifiable {
        case first, second
        
        var id: Int {
            hashValue
        }
    }
    
    //defining ML model
    let model: PamatkyModel = {
        do {
            let config = MLModelConfiguration()
            return try PamatkyModel(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create TestML model")
        }
    }()
    
    var body: some View {
        LoadingView(isShowing: $loading){
            GeometryReader { geo in
                ZStack{
                    // gray background
                    Rectangle()
                        .fill(Color.init(white: 0.93))
                        .frame(width: geo.size.width , height: geo.size.height, alignment: .center)
                        .accessibility(hidden: true)
                    //checking if there is a picture and if there is adding it
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width, height: geo.size.height)
                            
                            .padding(.bottom)
                    }
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                //presenting web sheet
                                activeSheet = .second
                                
                                // for launching corect functions
                                lastSheet = .second
                            }, label: {
                                Image(systemName: "info")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                        })
                            .padding(5)
                        }
                        Spacer()
                        //select picture button
                        Button(action: {
                            //presenting picker sheet
                            activeSheet = .first
                            // for launching corect functions
                            lastSheet = .first
                        }, label: {
                            Text("Tap to select picture!")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Capsule())
                                

                                
                        }).padding()
                        .accessibility(label: Text("select image button"))
                        .accessibilityRemoveTraits(.isButton)
                    }
                    
                    
                }
                // showing alert that is teling use what it is
                .alert(isPresented: $presentingAlert, content: {
                    Alert(title: Text( classification ?? "We don't know what's this.☹️ \n Try it later!"), message: Text(classificationWithLikness ?? "we don't know"), dismissButton: .default( Text("OK")))
                })
                
                // showing image picker
                .fullScreenCover(item: $activeSheet, onDismiss: onDismiss ) { item in
                            switch item {
                            case .first:
                                //na real device
                                CustomCameraView(image: self.$inputImage)
                                //MARK: na simulatoru odkomentnout radek nize
                            //ImagePicker(image: $inputImage)

                                //MARK: Dodělat
                            case .second: FullWebView(url: url)
                        }
                
                
                }
            }
        }
    }
    
    
  // MARK: Functions
    
    func onDismiss() {
        if lastSheet == .first {
        loadImage()
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { print("NO IMAGE!!!!"); return }
        image = Image(uiImage: inputImage)
        
        loading = true
//pushing work to background threath
        DispatchQueue.main.async {
            
            let imageToClassify = inputImage
            //resizing img. to corect size so ML model can classify it
            let resizedImg = imageToClassify.scalePreservingAspectRatio(targetSize: CGSize(width: 299, height: 299))

            
            //converting to buffer - needed for ML model
            guard let buffer = resizedImg.toCVPixelBuffer() else { print("neumí to konvertovat"); return }

            
            //classifying -- ignorovat nazvy faaaakt jsem nevedel jak to nazvat
            let classify = try? model.prediction(image: buffer)
            if let classifi = classify {
                classification = classifi.classLabel
                
                let likeness = classifi.classLabelProbs[classifi.classLabel]
                
                let percentage = Int(likeness! * 100)
                
                classificationWithLikness = "we are sure for \(percentage)%"
                
                print(classifi.classLabel + "   hurááááááá funguje toooo!!!!!!")
                print(classifi.classLabelProbs)
                
                
                let components = classifi.classLabel.components(separatedBy: " ")
                var urlcomponents = 0
                var stringforUrl = ""
                for i in components {
                    
                    if urlcomponents == 0 {
                        stringforUrl += i
                    }else {
                        stringforUrl += "+\(i)"
                    }
                    
                    urlcomponents += 1
                }
                let updatedC = stringforUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

                
                url = "https://www.wikipedia.org/search-redirect.php?family=wikipedia&language=en&search=\(updatedC)&language=cs"
                print(url)
            }else{
                print("tak uz faaaakt nevim 😭")
            }
        }

        hideAndPresent()
    }
    
    func hideAndPresent () {
        presentingAlert = true
        DispatchQueue.main.async {
            loading = false
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
