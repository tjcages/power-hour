//
//  PlayingView.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/7/22.
//

import SwiftUI
import UIKit

enum ActiveControl: Identifiable {
    case normal, shuffle
    
    var id: Int {
        hashValue
    }
}

struct PlayingSheet: View {
    @EnvironmentObject var spotify: SpotifyController
    
    @State private var loaded = false
//    @State private var activeControl: ActiveControl = .normal {
//        didSet {
//            if activeControl == .shuffle {
//                spotify.shufflePlaylist(true)
//            } else {
//                spotify.shufflePlaylist(false)
//            }
//        }
//    }
    
    private func getTime(_ count: Int) -> String {
        if count == 1 {
            return "1 minute"
        } else if count == 60 {
            return "1 hour"
        } else if count >= 60 && count < 120 {
            return "1+ hours"
        } else if count >= 120 {
            return "2 hours"
        } else {
            return "\(count) minutes"
        }
    }
    
    private func getCurrentSong() -> Song? {
        if let current = spotify.currentTrack {
            if spotify.viewingPlaylist?.id == spotify.currentPlaylist?.id {
                return current
            } else if let id = spotify.viewingPlaylist?.id, let songs = spotify.songs[id] {
                let filtered = songs.filter { song in
                    song.id == current.id
                }
                if filtered.count > 0 {
                    DispatchQueue.main.async {
                        self.spotify.currentPlaylist = self.spotify.viewingPlaylist
                    }
                    return filtered.first
                }
                return nil
            }
        }
        return nil
    }
    
    private func orderSongs(_ songs: [Song]) -> [Song] {
        var songs = songs
        
//        if activeControl == .shuffle {
//            songs.shuffle()
//        }
        
        return songs
    }
    
    var body: some View {
        if let playlist = spotify.viewingPlaylist {
            ZStack {
                CurrentArtwork(blur: true)
                
                //                Noise()
                
                ScrollView {
                    ScrollViewReader { value in
                        VStack(alignment: .leading, spacing: .medium) {
                            Handle()
                            
                            Text("POWER\nHOUR 🍻")
                                .font(.titleBrada)
                                .foregroundColor(.primary)
                                .padding(.bottom, .medium)
                            
                            Text(playlist.name ?? "")
                                .font(.mediumTitleBrada)
                                .foregroundColor(.primary)
                            
                            if let id = playlist.id, let count = spotify.songs[id]?.count, count > 0 {
                                Text("\(count == 1 ? "1 song" : "\(count) songs")  •  \(getTime(count))")
                                    .font(.headlineBrada)
                                    .foregroundColor(.secondary)
                            } else {
                                Rectangle()
                                    .frame(width: 160, height: 25)
                                    .background(Color.secondary)
                                    .opacity(0.2)
                                    .clipShape(RoundedRectangle(cornerRadius: .small, style: .continuous))
                            }
                            
                            ZStack {
                                CurrentArtwork()
                                
                                if let id = playlist.id, let songs = spotify.songs[id], songs.count > 0 {
                                    PlayButton() {
                                        spotify.startPowerHour(orderSongs(songs)[0], playlist)
                                        
                                        // Scroll to album artwork
                                        withAnimation {
                                            value.scrollTo("artwork", anchor: .top)
                                        }
                                    }
                                }
                            }
                            .id("artwork")
                            .padding(.top, .medium)
                            
                            if let song = getCurrentSong() {
                                TrackControls(song)
                            }
                            
                            if let id = playlist.id, let songs = spotify.songs[id], songs.count > 0 {
                                Divider()
                                    .divider()
                                
//                                HStack {
//                                    ControlButton("repeat", active: activeControl == .normal) {
//                                        activeControl = .normal
//                                    }
//                                    
//                                    ControlButton("shuffle", active: activeControl == .shuffle) {
//                                        activeControl = .shuffle
//                                    }
//                                    
//                                    Spacer()
//                                }
//                                .padding(.bottom, .medium)
                                
                                SongList(orderSongs(songs)) { song in
                                    if let playlist = spotify.viewingPlaylist {
                                        spotify.startPowerHour(song, playlist)
                                        
                                        // Scroll to album artwork
                                        withAnimation {
                                            value.scrollTo("artwork", anchor: .top)
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, .medium)
                        .padding(.bottom, .large * 2)
                        .animation(.easeOut, value: spotify.songs)
                    }
                }
                
                ToastView()
            }
            .edgesIgnoringSafeArea(.bottom)
        } else { EmptyView() }
    }
}
