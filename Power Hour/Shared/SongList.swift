//
//  SongList.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/14/22.
//

import SwiftUI

struct SongList: View {
    @EnvironmentObject var spotify: SpotifyController
    
    let songs: [Song]
    let callback: (Song) -> Void
    
    init(_ songs: [Song], _ callback: @escaping (Song) -> Void) {
        self.songs = songs
        self.callback = callback
    }
    
    var body: some View {
        VStack {            
            ForEach(songs) { song in
                let current = song.id == spotify.currentTrack?.id
                SongView(song, current: current, playing: spotify.playing) {
                    callback(song)
                }
            }
        }
        .padding(.bottom, .large * 2)
    }
}
