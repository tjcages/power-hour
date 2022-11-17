//
//  ProfileSheet.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/9/22.
//

import SwiftUI

struct ProfileSheet: View {
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var spotify: SpotifyController
    
    var body: some View {
        VStack {
            Handle()
            
            VStack(alignment: .leading) {
                Text("Profile")
                    .font(.largeTitleBrada)
                
                Group {
                    if let text = spotify.user?.name {
                        Text(text)
                    }
                    
                    if let text = spotify.user?.email {
                        Text(text)
                    }
                    
                    if let urlString = spotify.user?.uri, let url = URL(string: urlString) {
                        HStack {
                            Text("Spotify Account")
                            Image(systemName: "arrow.up.right")
                        }
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.spotifyGreen)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                openURL(url)
                            }
                    }
                }
                .font(.textBrada)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity)
                .padding(.vertical, .medium)
                .padding(.horizontal, .medium)
                .background(Color.containerColor)
                .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
            }
            
            Spacer()
            
            Button {
                spotify.signOutUser()
                dismiss()
            } label: {
                Text("Log out")
                    .font(.textBrada)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity)
                    .padding(.medium)
                    .background(Color.containerColor)
                    .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
            }
            .contentShape(Rectangle())
            .padding(.bottom, .medium)
        }
        .padding(.horizontal, .medium)
        .sheetColor()
    }
}
