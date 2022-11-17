//
//  BackgroundSheetView.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/14/22.
//

import SwiftUI

struct BackgroundSheetView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = UIColor(named: "sheet")
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
