//
//  BlurImageBackground.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/9/22.
//

import SwiftUI

struct BlurImageBackground: ViewModifier {
    let src: String?
    
    init(_ src: String?) {
        self.src = src
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundColor(.red)
            
            if let src = src, let url = URL(string: src) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .blur(radius: 100)
//                            .opacity(0.5)
                            .transition(.opacity)
                    default:
                        Rectangle()
                            .foregroundColor(.black.opacity(0.01))
                            .edgesIgnoringSafeArea(.all)
                            .blur(radius: 10)
                            .opacity(0.5)
                    }
                }
            }
            
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension View {
    func blurImageBackground(src: String?) -> some View {
        modifier(BlurImageBackground(src))
    }
}
