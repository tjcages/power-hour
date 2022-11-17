//
//  DividerModifier.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/14/22.
//

import SwiftUI

struct DividerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 1)
            .overlay(.primary)
            .opacity(0.2)
            .padding(.vertical, .small)
    }
}

extension View {
    func divider() -> some View {
        modifier(DividerModifier())
    }
}
