//
//  Fonts.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/9/22.
//

import SwiftUI

extension Font {
    static var largeTitleBrada: Font {
        Font.custom("Brada Sans", size: 72, relativeTo: .largeTitle).bold()
    }
    
    static var mediumTitleBrada: Font {
        Font.custom("Brada Sans", size: 56, relativeTo: .largeTitle).bold()
    }
    
    static var playIconLarge: Font {
        Font.custom("Brada Sans", size: 48, relativeTo: .largeTitle).bold()
    }
    
    static var playIcon: Font {
        Font.custom("Brada Sans", size: 28, relativeTo: .largeTitle).bold()
    }
    
    static var titleBrada: Font {
        Font.custom("Brada Sans", size: 24, relativeTo: .largeTitle).bold()
    }
    
    static var headlineBrada: Font {
        Font.custom("Brada Sans", size: 20, relativeTo: .largeTitle).bold()
    }
    
    static var textBrada: Font {
        Font.custom("Brada Sans", size: 16, relativeTo: .largeTitle).bold()
    }
}
