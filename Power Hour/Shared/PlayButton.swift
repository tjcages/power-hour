//
//  Play.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/9/22.
//

import SwiftUI

struct PlayButton: View {
    @EnvironmentObject var spotify: SpotifyController
    
    let callback: () -> Void
    
    init(_ callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    var body: some View {
        Button {
            callback()
        } label: {
            HStack(alignment: .center, spacing: .medium) {
                if let countdown = spotify.countdown {
                    if countdown >= 0 {
                        Text(String(format: "%02d", countdown))
                            .font(.titleBrada)
                            .foregroundColor(.primary)
                            .animation(.none, value: spotify.countdown)
                    } else {
                        Text("DRINK 🍻")
                            .font(.titleBrada)
                            .foregroundColor(.primary)
                    }
                } else if !spotify.playing {
                    Image(systemName: "play.fill")
                        .font(.system(size: .iconLarge))
                        .foregroundColor(.primary)
                    
                    Text("Let's drink")
                        .font(.headlineBrada)
                        .foregroundColor(.primary)
                }
            }
            .padding(.vertical, .mediumButton)
            .padding(.horizontal, .largeButton)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: .medium, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: .medium)
                    .stroke(.white.opacity(0.3), lineWidth: 2)
            )
            .scaleEffect(spotify.countdown ?? 0 < 0 ? CGSize(width: 1.2, height: 1.2) : CGSize(width: 1.0, height: 1.0))
            .opacity(spotify.playing && spotify.countdown == nil ? 0 : 1)
            .animation(.easeOut, value: spotify.nextSkip)
            .animation(.easeOut, value: spotify.countdown)
        }
        .contentShape(Rectangle())
    }
}
