//
//  HomePage.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/11/22.
//

import SwiftUI
import SafariServices

enum ActiveSheet: Identifiable {
    case profile, playlist
    
    var id: Int {
        hashValue
    }
}

struct HomePage: View {
    @EnvironmentObject var spotify: SpotifyController
    @State var activeSheet: ActiveSheet?
    @State var selectedPlaylist: Playlist? = nil
    
    @AppStorage(KeyValue.currentPlaylist.rawValue) private var currentPlaylist: String = ""
    
    var items: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                PullToRefresh() {
                    spotify.getUserPlaylists()
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: .large) {
                        HStack {
                            HStack(spacing: .small) {
                                Image("spotify")
                                    .resizable()
                                    .frame(width: .iconMedium, height: .iconMedium)
                                
                                Text("Spotify")
                                    .font(.titleBrada)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            Group {
                                if let href = spotify.user?.imageHref, let url = URL(string: href) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        default:
                                            Image(systemName: "person.fill")
                                        }
                                    }
                                    .onTapGesture {
                                        activeSheet = .profile
                                    }
                                } else {
                                    Image(systemName: "person.fill")
                                }
                            }
                            .frame(width: .iconLarge, height: .iconLarge)
                            .scaledToFit()
                            .aspectRatio(1, contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: .iconLarge, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: .medium)
                                    .stroke(.secondary.opacity(0.1), lineWidth: 2)
                            )
                        }
                        
                        Text("POWER HOUR 🍻")
                            .font(.largeTitleBrada)
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, .large)
                    
                    
                    Text("Your playlists:")
                        .font(.textBrada)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: items, spacing: 4) {
                        ForEach(spotify.playlists) { playlist in
                            PlaylistView(playlist)
                                .onTapGesture {
                                    spotify.getPlaylistTracks(playlist)
                                    
                                    activeSheet = .playlist
                                }
                        }
                    }
                }
                .padding(.horizontal, .medium)
                .padding(.bottom, .large * 2)
            }
            .coordinateSpace(name: "pullToRefresh")
            .dimEdges()
            .backgroundColor()
            
            if (spotify.currentTrack != nil) {
                CurrentlyPlayingView() {
                    if let playlist = spotify.currentPlaylist {
                        spotify.getPlaylistTracks(playlist)
                        
                        activeSheet = .playlist
                    } else {
                        let filteredPlaylists = spotify.playlists.filter { playlist in
                            playlist.id == currentPlaylist
                        }
                        if filteredPlaylists.count > 0 {
                            spotify.getPlaylistTracks(filteredPlaylists[0])
                            
                            activeSheet = .playlist
                        }
                    }
                }
            }
        }
        .onOpenURL { url in
            spotify.setAccessToken(from: url)
        }
        .sheet(item: $activeSheet,
            onDismiss: {
                activeSheet = nil
            }) { item in
            switch item {
            case .profile:
                ProfileSheet()
            case .playlist:
                PlayingSheet()
            }
        }
    }
}
