//
//  ControlButton.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/9/22.
//

import SwiftUI

struct ControlButton: View {
    let systemImage: String
    let active: Bool
    let callback: () -> Void
    
    init(_ systemImage: String, active: Bool, _ callback: @escaping () -> Void) {
        self.systemImage = systemImage
        self.active = active
        self.callback = callback
    }
    
    var body: some View {
        Button {
            callback()
        } label: {
            Image(systemName: systemImage)
            .font(.system(size: .iconShMedium))
            .foregroundColor(active ? .primary : .secondary)
            .padding(.vertical, .xSmallButton)
            .padding(.horizontal, .smallButton)
            .background(Color.secondary.opacity(active ? 0.2 : 0))
            .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: .small)
                    .stroke(Color.primary.opacity(active ? 0.9 : 0), lineWidth: 1)
            )
        }
        .contentShape(Rectangle())
    }
}

