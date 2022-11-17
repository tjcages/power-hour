//
//  Handle.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/9/22.
//

import SwiftUI

struct Handle: View {
    var body: some View {
        HStack {
            Spacer()
            
            Rectangle()
                .frame(width: 40, height: 4)
                .foregroundColor(.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
                .padding(.top, .small)
                .padding(.bottom, .small)
            
            Spacer()
        }
    }
}
