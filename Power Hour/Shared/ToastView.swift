//
//  Toast.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/11/22.
//

import SwiftUI

enum ErrorStates {
    case playlistError
    case songError
    case loginError
    case refreshError
    case creatingAccount
    case signingOut
    case fetchingUser
    case linkingSpotify
}

struct ToastView: View {
    @EnvironmentObject var spotify: SpotifyController
    
    @State private var visible = false
    @State private var error: String = ""
    @State private var solution: String = ""
    
    func getErrorDetails() -> (String, String) {
        if let errorState = spotify.error {
            switch(errorState) {
            case .playlistError:
                return ("Pull to refresh", "Error loading playlists")
            case .songError:
                return ("Close playlist & try again", "Error loading songs")
            case .loginError:
                return ("Refresh app & try again", "Error signing in")
            case .refreshError:
                return ("Log back in", "Spotify connection expired")
            case .creatingAccount:
                return ("Sorry, please try again", "Error creating account")
            case .signingOut:
                return ("Refresh app & try again", "Error signing out")
            case .fetchingUser:
                return ("Refresh app & try again", "Error fetching account")
            case .linkingSpotify:
                return ("Sorry, please try again", "Error linking Spotify")
            }
        } else { return ("", "") }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text(solution)
                    .font(.headlineBrada)
                    .foregroundColor(.primary)
                
                Text(error)
                    .font(.textBrada)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, .small)
            .padding(.horizontal, .medium)
            .background(Color.red.opacity(0.8))
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: .medium, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: .medium)
                .stroke(Color.red.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal, .medium * 2)
        .padding(.bottom, .medium)
        .opacity(visible ? 1 : 0)
        .offset(CGSize(width: 0, height: visible ? 0 : 70))
        .allowsHitTesting(false)
        .onChange(of: spotify.error) { newValue in
            if let _ = newValue {
                let (solution, error) = getErrorDetails()
                self.solution = solution
                self.error = error
                
                withAnimation {
                    visible = true
                }
                delay(3) {
                    spotify.error = nil
                    withAnimation {
                        visible = false
                    }
                }
            } else {
                withAnimation {
                    visible = false
                }
            }
        }
    }
}
