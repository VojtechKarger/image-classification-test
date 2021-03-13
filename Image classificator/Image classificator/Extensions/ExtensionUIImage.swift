//
//  ExtensionUIImage.swift
//  Image classificator
//
//  Created by vojta on 13.03.2021.
//

import UIKit

extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }

        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)

            UIGraphicsPushContext(context!)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

            return pixelBuffer
        }

        return nil
    }
    
    
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
           // Determine the scale factor that preserves aspect ratio
           let widthRatio = targetSize.width / size.width
           let heightRatio = targetSize.height / size.height
           
           let scaleFactor = min(widthRatio, heightRatio)
           
           // Compute the new image size that preserves aspect ratio
           let scaledImageSize = CGSize(
               width: size.width * scaleFactor,
               height: size.height * scaleFactor
           )

           // Draw and return the resized UIImage
           let renderer = UIGraphicsImageRenderer(
               size: scaledImageSize
           )

           let scaledImage = renderer.image { _ in
               self.draw(in: CGRect(
                   origin: .zero,
                   size: scaledImageSize
               ))
           }
           
           return scaledImage
       }
}
