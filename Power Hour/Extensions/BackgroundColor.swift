//
//  Background.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/9/22.
//

import SwiftUI

struct Background: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
    }
}

struct Sheet: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.sheetColor.edgesIgnoringSafeArea(.all))
    }
}

extension View {
    func backgroundColor() -> some View {
        modifier(Background())
    }
    
    func sheetColor() -> some View {
        modifier(Sheet())
    }
}
