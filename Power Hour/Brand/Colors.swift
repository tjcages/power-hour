//
//  Colors.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/9/22.
//

import SwiftUI

extension Color {
    // Standard
    static let backgroundColor: Color = Color("view")
    static let sheetColor: Color = Color("sheet")
    static let containerColor: Color = Color("container")
    
    // Text
    static let primary: Color = Color("primary")
//    static let secondary: Color = Color("secondary")
    static let secondary: Color = Color("primary").opacity(0.7)
    
    // Specialty
    static let spotifyGreen: Color = Color("spotifyGreen")
    static let red: Color = Color("red")
}
