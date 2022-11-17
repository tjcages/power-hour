//
//  GryroPlaylistView.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/11/22.
//

import SwiftUI

struct GyroPlaylistView: View {
    @State private var loaded = false
    
    let imageHref: String
    
    init(_ imageHref: String) {
        self.imageHref = imageHref
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageHref)) { phase in
                switch phase {
                case .success(let image):
                    ZStack {
                        image
                            .resizable()
                            .scaledToFill()
                            .opacity(loaded ? 1 : 0)
                        
                        Rectangle()
                            .foregroundColor(.secondary.opacity(0.3))
                            .blur(radius: 10)
                            .opacity(loaded ? 0 : 0.5)
                    }
                    .onAppear {
                        withAnimation {
                            loaded.toggle()
                        }
                    }
                default:
                    Rectangle()
                        .foregroundColor(.secondary.opacity(0.3))
                        .blur(radius: 10)
                        .opacity(0.5)
                }
            }
            .scaledToFit()
            .aspectRatio(1, contentMode: .fit)
            .blur(radius: 1)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

