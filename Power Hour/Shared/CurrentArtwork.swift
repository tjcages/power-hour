//
//  CurrentArtwork.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/14/22.
//

import SwiftUI

struct CurrentArtwork: View {
    @EnvironmentObject var spotify: SpotifyController
    
    @State private var loaded = false
    @State private var currentImage: Any?
    
    let blur: Bool
    
    init(blur: Bool = false) {
        self.blur = blur
    }
    
    var body: some View {
        ZStack {
            if spotify.viewingPlaylist?.id == spotify.currentPlaylist?.id, let current = spotify.currentTrack, let image = current.image {
                Image(uiImage: image)
                    .resizable()
                    .if(!blur, transform: { image in
                        image
                            .scaledToFit()
                            .aspectRatio(1, contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: .small)
                                    .stroke(.secondary.opacity(0.1), lineWidth: blur ? 0 : 2)
                            )
                    })
                    .if(blur, transform: { image in
                        image
                            .edgesIgnoringSafeArea(.all)
                            .blur(radius: 100)
                    })
                    .animation(.easeOut, value: spotify.currentTrack)
                    .onAppear {
                        withAnimation {
                            loaded = true
                        }
                    }
            } else if let urlString = spotify.viewingPlaylist?.imageHref, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .if(!blur, transform: { image in
                                image
                                    .scaledToFill()
                            })
                            .if(blur, transform: { image in
                                image
                                    .edgesIgnoringSafeArea(.all)
                                    .blur(radius: 100)
                            })
                            .opacity(loaded ? 1 : 0)
                            .onAppear {
                                withAnimation {
                                    loaded = true
                                }
                            }
                    default:
                        Rectangle()
                            .background(Color.containerColor)
                            .opacity(0.5)
                    }
                }
                .if(!blur, transform: { image in
                    image
                        .scaledToFit()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: .small)
                                .stroke(.secondary.opacity(0.1), lineWidth: 2)
                        )
                })
                .if(blur) { image in
                    image
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
            
            Rectangle()
                .if(!blur, transform: { view in
                    view
                        .background(Color.containerColor)
                        .opacity(loaded ? 0 : 0.5)
                        .clipShape(RoundedRectangle(cornerRadius: .medium, style: .continuous))
                })
                .if(blur, transform: { view in
                    view
                        .foregroundColor(.secondary.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 10)
                        .opacity(0.4)
                })
        }
    }
}
