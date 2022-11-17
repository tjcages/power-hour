//
//  SongView.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/7/22.
//

import SwiftUI

struct SongView: View {
    let song: Song
    let current: Bool
    let playing: Bool
    let callback: () -> Void
    
    init(_ song: Song, current: Bool = false, playing: Bool = false, _ callback: @escaping () -> Void) {
        self.song = song
        self.current = current
        self.playing = playing
        self.callback = callback
    }
    
    var body: some View {
        Button {
            callback()
        } label: {
            HStack(spacing: .small) {
                if let urlString = song.imageHref, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            Rectangle()
                                .foregroundColor(.secondary.opacity(0.3))
                                .blur(radius: 10)
                                .opacity(0.5)
                        }
                    }
                    .scaledToFit()
                    .frame(maxWidth: .large)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
                }
                
                VStack(alignment: .leading) {
                    Text(song.title ?? "")
                        .font(.headlineBrada)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(song.artist ?? "")
                        .font(.textBrada)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if current {
                    Group {
                        if playing {
                            AnimatedWaveformView(color: .primary, renderingMode: .palette, secondaryColor: .clear, animated: true)
                        } else {
                            AnimatedWaveformView(color: .primary, renderingMode: .palette, secondaryColor: .clear, animated: false)
                        }
                    }
                    .frame(width: .iconXLarge, height: .iconXLarge)
                    .offset(CGSize(width: .small, height: 0))
                    .opacity(playing ? 1 : 0.5)
                }
            }
            .padding(.vertical, .small)
            .padding(.horizontal, .xSmall)
            .opacity(song.played ? 0.5 : 1)
        }
        .contentShape(Rectangle())
    }
}
