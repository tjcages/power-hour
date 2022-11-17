//
//  CurrentlyPlayingView.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/14/22.
//

import SwiftUI

struct CurrentlyPlayingView: View {
    @EnvironmentObject var spotify: SpotifyController
    
    @State private var loaded = false
    
    let callback: () -> Void
    
    var body: some View {
        Button {
            callback()
        } label: {
            HStack(alignment: .center, spacing: .small) {
                if let urlString = spotify.currentTrack?.imageHref, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
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
                                .opacity(loaded ? 0 : 0.5)
                        }
                    }
                    .scaledToFit()
                    .frame(maxWidth: .large)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
                } else if let image = spotify.currentTrack?.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .large)
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
                } else {
                    Rectangle()
                        .foregroundColor(.secondary.opacity(0.3))
                        .blur(radius: 10)
                        .scaledToFit()
                        .frame(maxWidth: .large)
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
                }
                
                VStack(alignment: .leading) {
                    Text(spotify.currentTrack?.title ?? "")
                        .font(.textBrada)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    
                    Text(spotify.currentTrack?.artist ?? "")
                        .font(.textBrada)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button {
                    if spotify.playing {
                        spotify.pauseTrack()
                    } else {
                        spotify.resumeTrack()
                    }
                } label: {
                    Image(systemName: spotify.playing ? "pause.fill" : "play.fill")
                        .font(.playIcon)
                        .foregroundColor(.primary)
                        .padding(.small)
                }
                .contentShape(Rectangle())
                .frame(height: .medium * 2)
                
                Button {
                    spotify.skipTrack()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.headlineBrada)
                        .foregroundColor(.primary)
                        .padding(.small)
                }
                .contentShape(Rectangle())
            }
            .frame(maxWidth: .infinity)
            .padding(.medium)
        }
        .contentShape(Rectangle())
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: .largeButton, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: .largeButton)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        )
        .padding([.horizontal, .bottom], .small)
    }
}
