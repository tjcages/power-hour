//
//  PlaylistView.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/7/22.
//

import SwiftUI

struct PlaylistView: View {
    @State private var loaded = false
    
    let playlist: Playlist
    
    init(_ playlist: Playlist) {
        self.playlist = playlist
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: playlist.imageHref ?? "")) { phase in
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
                            loaded = true
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
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            if let name = playlist.name {
                Text(name)
                    .font(.textBrada)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical)
    }
}
