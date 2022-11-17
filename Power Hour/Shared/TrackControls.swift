//
//  TrackControls.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/14/22.
//

import SwiftUI

struct TrackControls: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var spotify: SpotifyController
    
    let song: Song
    
    init(_ song: Song) {
        self.song = song
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(song.title ?? "")
                        .font(.titleBrada)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, .xSmall)
                    
                    Text(song.artist ?? "")
                        .font(.headlineBrada)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, .xSmall)
                }
                
                Spacer()
                
                if let uri = song.uri, let url = URL(string: uri) {
                    Button {
                        openURL(url)
                    } label: {
                        Image("spotify")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.secondary)
                            .frame(width: .iconMedium, height: .iconMedium)
                            .padding(.small)
                    }
                    .contentShape(Rectangle())
                }
            }
            
            HStack {
                Spacer()
                
                Button {
                    spotify.replayTrack()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.playIcon)
                        .foregroundColor(.primary)
                        .padding(.small)
                }
                .contentShape(Rectangle())
                
                Spacer()
                
                Button {
                    if spotify.playing {
                        spotify.pauseTrack()
                    } else {
                        spotify.resumeTrack()
                    }
                } label: {
                    Image(systemName: spotify.playing ? "pause.fill" : "play.fill")
                        .font(.playIconLarge)
                        .foregroundColor(.primary)
                        .padding(.small)
                }
                .contentShape(Rectangle())
                .frame(height: .medium * 2)
                
                Spacer()
                
                Button {
                    spotify.skipTrack()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.playIcon)
                        .foregroundColor(.primary)
                        .padding(.small)
                }
                .contentShape(Rectangle())
                
                Spacer()
            }
            .padding(.vertical, .medium)
        }
    }
}
