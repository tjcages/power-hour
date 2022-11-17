//
//  ContentView.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/7/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var spotify: SpotifyController
    @AppStorage(KeyValue.authenticated.rawValue) private var authenticated: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if authenticated {
                HomePage()
            } else {
                LoginPage()
            }
            
            ToastView()
        }
        .preferredColorScheme(.dark)
    }
}
