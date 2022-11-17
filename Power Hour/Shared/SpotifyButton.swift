//
//  SpotifyButton.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/11/22.
//

import SwiftUI

struct SpotifyButton: View {
    let callback: () -> Void
    
    init(_ callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    var body: some View {
        Button {
            callback()
        } label: {
            HStack(alignment: .center, spacing: .medium) {
                Image("spotify")
                    .resizable()
                    .frame(width: .iconMedium, height: .iconMedium)
                
                Text("Login to Spotify")
                    .font(.headlineBrada)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, .mediumButton)
            .padding(.horizontal, .largeButton)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: .medium, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: .medium)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
        }
        .contentShape(Rectangle())
    }
}
