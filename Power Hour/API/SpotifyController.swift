//
//  SpotifyController.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/12/22.
//

import SwiftUI
import SpotifyiOS

extension SpotifyController: SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { _, _ in })
        
        self.checkForJobs()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        if let _ = error, playing {
            appRemote.authorizeAndPlayURI("")
        }
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        if let _ = error, playing {
            appRemote.connect()
        }
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        if !playerState.isPaused {
            playing = true
            
            let split = playerState.track.uri.split(separator: ":")
            if split.count <= 0 { return playing = false }
            let id = String(split[split.count - 1])
            
            if let playlistId = currentPlaylist?.id, let songs = songs[playlistId] {
                let filtered = songs.filter { song in
                    song.id == id
                }
                if filtered.count > 0 {
                    currentTrack = filtered.first
                    
                    // Set currently playing song to played
                    if let index = self.songs[id]?.firstIndex(where: { track in
                        track.id == currentTrack?.id
                    }) {
                        self.songs[id]?[index].played = true
                    }
                }
            }
            
            // Update currently playing track's associated image
            appRemote.imageAPI?.fetchImage(forItem: playerState.track, with: CGSize(width: 600, height: 600)) { result, error in
                if let error = error {
                    print("Error fetching currently playing song: \(error)")
                    
                    self.currentTrack = Song([
                        "id": id,
                        "title": playerState.track.name,
                        "artist": playerState.track.artist.name,
                        "uri": playerState.track.uri,
                        "duration": playerState.track.duration,
                    ], sdk: true)
                }
                if let image = result as? UIImage {
                    self.currentTrack = Song([
                        "id": id,
                        "title": playerState.track.name,
                        "artist": playerState.track.artist.name,
                        "uri": playerState.track.uri,
                        "duration": playerState.track.duration,
                        "image": image
                    ], sdk: true)
                }
            }
        } else {
            playing = false
        }
    }
}
