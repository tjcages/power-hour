//
//  Noise.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/12/22.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct Noise: View {
    @State private var image: UIImage?
    
    init() {
        makeUIView()
    }
    
    func makeUIView() {
        let view = CIImage()
        var image = UIImage()
        
        let context = CIContext()
        
        guard
            let colorNoise = CIFilter(name:"CIRandomGenerator"),
            let noiseImage = colorNoise.outputImage
            else {
            return
        }
        
        let whitenVector = CIVector(x: 0, y: 1, z: 0, w: 0)
        let fineGrain = CIVector(x:0, y:0.005, z:0, w:0)
        let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
        guard
            let whiteningFilter = CIFilter(name:"CIColorMatrix",
                                           parameters:
            [
                kCIInputImageKey: noiseImage,
                "inputRVector": whitenVector,
                "inputGVector": whitenVector,
                "inputBVector": whitenVector,
                "inputAVector": fineGrain,
                "inputBiasVector": zeroVector
            ]),
            let whiteSpecks = whiteningFilter.outputImage
            else {
            return
        }
        
        guard let sepiaFilter = CIFilter(name:"CISepiaTone",
                                         parameters:
            [
                  kCIInputImageKey: image,
                  kCIInputIntensityKey: 1.0
            ]) else {
                  return
            }
        
        guard let sepiaCIImage = sepiaFilter.outputImage else {
            return
        }
        
        guard
            let speckCompositor = CIFilter(name:"CISourceOverCompositing",
                                           parameters:
            [
                kCIInputImageKey: whiteSpecks,
                kCIInputBackgroundImageKey: sepiaCIImage
            ]),
            let view = speckCompositor.outputImage
            else {
                return
        }
        
        if let cgimg = context.createCGImage(view, from: view.extent) {
            // convert that to a UIImage
            let uiImage = UIImage(cgImage: cgimg)

            // and convert that to a SwiftUI image
            // DONE
            self.image = uiImage
        }
    }
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red)
        }
    }
}

//struct Noise: UIViewRepresentable {
//    func makeUIView(context: Context) -> Image {
//        var view = CIImage()
//        var image = Image("")
//
//        let context = CIContext()
//        let currentFilter = CIFilter.sepiaTone()
//
//        guard
//            let colorNoise = CIFilter(name:"CIRandomGenerator"),
//            let noiseImage = colorNoise.outputImage
//            else {
//            return image
//        }
//
//        let whitenVector = CIVector(x: 0, y: 1, z: 0, w: 0)
//        let fineGrain = CIVector(x:0, y:0.005, z:0, w:0)
//        let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
//        guard
//            let whiteningFilter = CIFilter(name:"CIColorMatrix",
//                                           parameters:
//            [
//                kCIInputImageKey: noiseImage,
//                "inputRVector": whitenVector,
//                "inputGVector": whitenVector,
//                "inputBVector": whitenVector,
//                "inputAVector": fineGrain,
//                "inputBiasVector": zeroVector
//            ]),
//            let whiteSpecks = whiteningFilter.outputImage
//            else {
//            return image
//        }
//
//        guard let sepiaFilter = CIFilter(name:"CISepiaTone",
//                                         parameters:
//            [
//                  kCIInputImageKey: view,
//                  kCIInputIntensityKey: 1.0
//            ]) else {
//                  return image
//            }
//
//        guard let sepiaCIImage = sepiaFilter.outputImage else {
//            return image
//        }
//
//        guard
//            let speckCompositor = CIFilter(name:"CISourceOverCompositing",
//                                           parameters:
//            [
//                kCIInputImageKey: whiteSpecks,
//                kCIInputBackgroundImageKey: sepiaCIImage
//            ]),
//            let view = speckCompositor.outputImage
//            else {
//                return image
//        }
//
//        if let cgimg = context.createCGImage(view, from: view.extent) {
//            // convert that to a UIImage
//            let uiImage = UIImage(cgImage: cgimg)
//
//            // and convert that to a SwiftUI image
//            image = Image(uiImage: uiImage)
//        }
//
//        return image
//    }
//
//    func updateUIView(_ uiView: Image, context: Context) {
//    }
//}
