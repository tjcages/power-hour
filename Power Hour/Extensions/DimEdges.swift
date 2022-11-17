//
//  DimEdges.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/9/22.
//

import SwiftUI

struct Dim: ViewModifier {
    let top: Bool
    let bottom: Bool
    
    init(_ top: Bool, _ bottom: Bool) {
        self.top = top
        self.bottom = bottom
    }
    
    func body(content: Content) -> some View {
        content
            // top dim gradient
            .if(top, transform: { view in
                view.mask (
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black]), startPoint: .top, endPoint: .bottom)
                )
            })
            // bottom dim gradient
            .if(bottom, transform: { view in
                view
                    .mask (
                        LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black, Color.black, Color.black.opacity(0.7), Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                )
            })
    }
}

struct ReverseDim: ViewModifier {
    func body(content: Content) -> some View {
        content
            .mask (
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.3), Color.black.opacity(0.1), Color.black.opacity(0.2), Color.black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
            )
    }
}

extension View {
    func dimEdges(top: Bool = true, bottom: Bool = true) -> some View {
        modifier(Dim(top, bottom))
    }
    
    func reverseDim() -> some View {
        modifier(ReverseDim())
    }
}
