//
//  SpotifyAPIs.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/7/22.
//

import SwiftUI
import FirebaseMessaging
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions
import SpotifyiOS
import Combine

enum KeyValue: String {
    case authenticated, accessToken, currentPlaylist
}

enum TriggerFunction: String {
    case getAuthorizationURL,
         grantAuthorization,
         getUsersPlaylists,
         getPlaylistTracks,
         playSong,
         powerHour,
         resumePlayback,
         pausePlayback,
         skipPlayback,
         previousPlayback
}

struct Job {
    let song: Song
    let playlist: Playlist
    
    init(_ song: Song, _ playlist: Playlist) {
        self.song = song
        self.playlist = playlist
    }
}

class SpotifyController: NSObject, ObservableObject {
    private let auth = Auth.auth()
    let store = Firestore.firestore()
    private let functions = Functions.functions()
    
    private let usersPath: String = "users"
    let accessPath: String = "access"
    private let playingPath: String = "playing"
    
    private let userDefaults = UserDefaults.standard
    
    private let startTime = 10000
    private let buffer = 6
    private let canOpeningUri = "spotify:track:5a04m67QmqhamAehwaOzqX"
    
    @Published var authenticationURL: String? = nil
    @Published var uid: String?
    @Published var user: UserData?
    @Published var playlists: [Playlist] = []
    @Published var songs = [String: [Song]]()
    @Published var error: ErrorStates? = nil
    
    @Published private var timer: Timer?
    @Published var countdown: Int?
    @Published var nextSkip: Date? {
        didSet {
            if timer != nil {
                timer!.invalidate()
                countdown = nil
            }
            if let date = nextSkip {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    if self.playing {
                        var time = -1
                        
                        let interval = date - Date()
                        if let seconds = interval.second {
                            time = seconds + self.buffer
                        }
                        
                        if time >= 0 {
                            self.countdown = time
                        } else {
                            self.countdown = -1
                        }
                    }
                })
            }
        }
    }
    
    @Published var job: Job? = nil
    
    // MARK: User Controls
    @Published var viewingPlaylist: Playlist?
    @Published var currentPlaylist: Playlist? {
        didSet {
            if let id = currentPlaylist?.id {
                self.userDefaults.set(id, forKey: KeyValue.currentPlaylist.rawValue)
            }
        }
    }
    @Published var currentTrack: Song?
    @Published var playing: Bool = false
    
    @Published private var refresh: String?
    
    @AppStorage(KeyValue.accessToken.rawValue) private var accessToken: String = ""
    
    lazy var configuration = SPTConfiguration(
        clientID: "20c86eb0725f4b9aa47c9b95b5f73cc3",
        redirectURL: URL(string: "comtylerjpowerhour://oauth-callback/spotify")!
    )
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = accessToken
        appRemote.delegate = self
        
        return appRemote
    }()
    
    override init() {
        super.init()
        
        monitorAuth()
    }
    
    
    // MARK: -- AUTHENTICATION
    private func monitorAuth() {
        uid = nil
        auth.addStateDidChangeListener { auth, user in
            if let user = user {
                self.userDefaults.set(true, forKey: KeyValue.authenticated.rawValue)
                self.appRemote.connectionParameters.accessToken = self.accessToken
                self.uid = user.uid
                
                // Get user details & playlist data async
                self.getUserData()
                self.getUserPlaylists()
                self.connectPlayer()
                self.subscribeToPlaying()
                self.registerRemoteNotifications()
            } else {
                self.userDefaults.set(false, forKey: KeyValue.authenticated.rawValue)
                
                self.uid = nil
                self.user = nil
                self.playlists = []
                self.songs = [String: [Song]]()
                
                // Get the Spotify authorization URL immediately
                self.triggerAuthorizationFlow()
            }
        }
    }
    
    // Sign in the user
    private func signInUser() {
        guard let user = user, let email = user.email, let id = user.id else { return }
        auth.signIn(withEmail: email, password: id.toBase64()) { (authResponse, error) in
            if let user = authResponse?.user {
                self.uid = user.uid
                self.saveUserToken()
            }
            if authResponse?.user == nil {
                self.createNewUserAuth()
            }
            if let error = error {
                print("Error signing in user: \(error)")
                
                self.error = .loginError
            }
        }
    }
    
    // Create new user
    private func createNewUserAuth() {
        guard let user = user, let email = user.email, let id = user.id else { return }
        auth.createUser(withEmail: email, password: id.toBase64()) { (authResponse, error) in
            if let user = authResponse?.user {
                self.uid = user.uid
                self.saveUserData()
                self.saveUserToken()
            }
            if let error = error {
                print("Error creating new user: \(error)")
                
                self.error = .creatingAccount
            }
        }
    }
    
    public func signOutUser() {
        do {
            try auth.signOut()
            
            if let uid = uid {
                return store.collection(accessPath).document(uid).delete()
            }
        } catch let error as NSError {
            print("Error signing out: \(error)")
            
            self.error = .signingOut
        }
    }
    
    
    // MARK: -- USER DATA
    private func getUserData() {
        guard let uid = uid else { return }
        store.collection(usersPath).document(uid).getDocument(completion: { snapshot, error in
            if
                snapshot?.exists == true,
                let data = snapshot?.data()
            {
                // User exists, get data
                self.user = UserData(data, database: true)
            }
            if let error = error {
                print("Error fetching user", error.localizedDescription)
                
                self.error = .fetchingUser
            }
        })
    }
    
    private func saveUserData() {
        guard let uid = uid, var data = user?.dictionary else { return }
        data["uid"] = uid
        
        return store.collection(usersPath).document(uid).setData(data)
    }
    
    // Save user data & refresh token to Firestore
    private func saveUserToken() {
        guard let uid = uid, let user = user, let id = user.id, let refresh = refresh else { return }
        
        return store.collection(accessPath).document(uid).setData(["refreshToken": refresh, "id": id])
    }
    
    
    // MARK: -- MUSIC PROVIDER AUTHENTICATION FLOW
    
    // ON USER CLICK SPOTIFY LOGIN
    // Start the redirect to Spotify authorization flow
    public func triggerAuthorizationFlow() {
        functions.httpsCallable(TriggerFunction.getAuthorizationURL.rawValue).call() { (result, error) in
            if let data = result?.data as? String {
                self.authenticationURL = data
            } else {
                if let error = error {
                    print("Get authorization function error: \(error)")
                    
                    self.error = .linkingSpotify
                }
                
                return
            }
        }
    }
    
    // Users completing authorization flow
    // Get access & refresh tokens
    public func grantUserAccess(_ code: String) {
        grantAuthorization(code) {
            self.signInUser()
        }
    }
    
    // Use authorization code to receive access & refresh tokens from Spotify
    private func grantAuthorization(_ code: String, _ callback: @escaping () -> Void) {
        functions.httpsCallable(TriggerFunction.grantAuthorization.rawValue).call(["code": code]) { (result, error) in
            if
                let data = result?.data as? [String: Any],
                let status = data["status"] as? String,
                status == "success",
                let response = data["response"] as? [String : Any],
                let refreshToken = response["refresh_token"] as? String,
                let accessToken = response["access_token"] as? String,
                let userData = data["user"] as? [String: Any]
            {
                self.user = UserData(userData)
                self.refresh = refreshToken
                
                // Set access for Spotify player
                self.userDefaults.set(accessToken, forKey: KeyValue.accessToken.rawValue)
                self.appRemote.connectionParameters.accessToken = accessToken
                
                callback()
            } else {
                // Error calling function
                if let error = error {
                    print("Error in authorization grant function: \(error)")
                    
                    self.error = .linkingSpotify
                }
                // Error returned from function
                if
                    let data = result?.data as? [String: Any],
                    let status = data["status"] as? String,
                    status == "error",
                    let errorMessage = data["message"] as? String
                {
                    print("Error getting authorization grant: \(errorMessage)")
                    
                    self.error = .linkingSpotify
                }
                print("Error getting authorization grant")
                
                self.error = .linkingSpotify
                
                self.user = nil
                self.refresh = nil
                
                callback()
            }
        }
    }
    
    private func registerRemoteNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        UIApplication.shared.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
    }
    
    
    // MARK: -- MUSIC PROVIDER
    
    // Get user playlists from uid
    public func getUserPlaylists() {
        guard let uid = uid else { return }
        
        playlists = [] // reset the view
        functions.httpsCallable(TriggerFunction.getUsersPlaylists.rawValue).call(["uid": uid]) { (result, error) in
            if
                let data = result?.data as? [String: Any],
                let response = data["response"] as? [String: Any],
                let playlists = response["items"] as? [[String: Any]]
            {
                playlists.forEach { playlist in
                    let playlistData = Playlist(playlist)
                    self.playlists.append(playlistData)
                }
            } else {
                // Error calling function
                if let error = error {
                    print("Error in playlist data function: \(error)")
                    
                    self.error = .playlistError
                }
                // Error returned from function
                if
                    let data = result?.data as? [String: Any],
                    let status = data["status"] as? String,
                    status == "expired"
                {
                    print("Refresh token expired")
                    self.error = .refreshError
                    
                    self.signOutUser()
                }
                // Other unknown error
                print("Error getting playlist data: \(String(describing: result?.data))")
                
                self.error = .playlistError
            }
        }
    }
    
    // Get user playlist tracks
    public func getPlaylistTracks(_ playlist: Playlist) {
        viewingPlaylist = playlist
        
        guard let uid = uid, let id = playlist.id else { return }
        // Init songs object
        songs[id] = []
        functions.httpsCallable(TriggerFunction.getPlaylistTracks.rawValue).call(["uid": uid, "playlistId": id]) { (result, error) in
            if
                let data = result?.data as? [String: Any],
                let status = data["status"] as? String,
                status == "success",
                let response = data["response"] as? [String: Any],
                let tracks = response["tracks"] as? [String: Any],
                let songs = tracks["items"] as? [[String: Any]]
            {
                songs.forEach { song in
                    var songData = Song(song)
                    if let current = self.currentTrack {
                        songData.played = songData.id == current.id
                    }
                    self.songs[id]?.append(songData)
                }
            } else {
                // Error calling function
                if let error = error {
                    print("Error in playlist tracks function: \(error)")
                    
                    self.error = .songError
                }
                // Error returned from function
                if
                    let data = result?.data as? [String: Any],
                    let status = data["status"] as? String,
                    status == "expired"
                {
                    print("Refresh token expired")
                    self.error = .refreshError
                    
                    self.signOutUser()
                }
                
                print("Error getting track data: \(String(describing: result?.data))")
                
                self.error = .songError
            }
        }
    }
    
    
    // MARK: -- SPOTIFY PLAYER
    
    public func connectPlayer() {
        guard let _ = appRemote.connectionParameters.accessToken else {
            appRemote.authorizeAndPlayURI("")
            
            return
        }
        
        appRemote.connect()
    }
    
    public func startPowerHour(_ song: Song, _ playlist: Playlist) {
        // Ensure connection to Spotify
        appRemote.connect()
        if appRemote.isConnected {
            // Connected
            playSong(song, playlist)
        } else {
            // Disconnected
            // Authorize connection again
            appRemote.authorizeAndPlayURI(canOpeningUri) // Can opening
            
            // Save to a job when authorized
            job = Job(song, playlist)
        }
    }
    
    func checkForJobs() {
        // Check for pending jobs
        if let job = job {
            // Play if a job exists
            playSong(job.song, job.playlist)
        }
    }
    
    func playSong(_ song: Song, _ playlist: Playlist) {
        // Remove any pending jobs
        job = nil
        
        guard let uid = uid else { return }
        // Set currently playing song to played
        if let id = playlist.id, let uri = playlist.uri, let index = songs[id]?.firstIndex(where: { track in
            track.id == song.id
        }) {
            // Set published variables
            currentTrack = song
            currentPlaylist = playlist
            songs[id]?[index].played = true
            
            // Play song from playlist
            functions.httpsCallable(TriggerFunction.playSong.rawValue).call(["uid": uid, "uri": uri, "position": index, "start": startTime]) { (result, error) in
                if let error = error {
                    print("Error starting Power Hour: \(error)")
                }
                self.nextSkip = Timestamp().dateValue()
                
                // Trigger Power Hour
                self.functions.httpsCallable(TriggerFunction.powerHour.rawValue).call(["uid": uid, "uri": uri, "position": index, "start": self.startTime]) { (result, error) in
                    if let error = error {
                        print("Error starting Power Hour: \(error)")
                    }
                }
            }
        }
    }
    
    private func subscribeToPlaying() {
        guard let uid = uid else { return }
        store.collection(playingPath).document(uid).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error setting snapshot listener: \(error)")
                return
            }
            guard let document = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            if let data = document.data() {
                let timestamp = data["nextSkip"] as? Timestamp
                self.nextSkip = timestamp?.dateValue()
            } else {
                self.nextSkip = nil
            }
        }
    }
    
    //    public func shufflePlaylist(_ shuffle: Bool) {
    //        if !appRemote.isConnected { appRemote.connect() }
    //        appRemote.playerAPI?.setShuffle(shuffle)
    //    }
    
    public func pauseTrack() {
        guard let uid = uid else { return }
        if playing {
            // Delete the next skip
            store.collection(playingPath).document(uid).delete()
            
            // Attempt to pause song locally
            if appRemote.isConnected {
                appRemote.playerAPI?.pause() { _,_ in
                    self.playing = false
                }
            } else {
                // Else trigger backend function to resume
                functions.httpsCallable(TriggerFunction.pausePlayback.rawValue).call(["uid": uid]) { (result, error) in
                    if let error = error {
                        print("Error pause playback: \(error)")
                    }
                    self.playing = false
                }
            }
        }
    }
    
    public func resumeTrack() {
        guard let uid = uid else { return }
        if !playing {
            // Attempt to resume song locally
            if appRemote.isConnected {
                appRemote.playerAPI?.resume() { _,_ in
                    self.playing = true
                }
            } else {
                // Else trigger backend function to resume
                functions.httpsCallable(TriggerFunction.pausePlayback.rawValue).call(["uid": uid]) { (result, error) in
                    if let error = error {
                        print("Error resuming playback: \(error)")
                    }
                    self.playing = true
                }
            }
            
            // Trigger new Power Hour
            if let id = currentPlaylist?.id, let uri = currentPlaylist?.uri, let index = songs[id]?.firstIndex(where: { track in
                track.id == currentTrack?.id
            }) {
                functions.httpsCallable(TriggerFunction.powerHour.rawValue).call(["uid": uid, "uri": uri, "position": index, "start": startTime]) { (result, error) in
                    if let error = error {
                        print("Error starting Power Hour: \(error)")
                    }
                }
            }
        }
    }
    
    public func skipTrack() {
        // Attempt to skip song locally
        if appRemote.isConnected {
            appRemote.playerAPI?.skip(toNext: { _, _ in
                self.playing = true
            })
        } else {
            // Else trigger backend function to skip
            functions.httpsCallable(TriggerFunction.skipPlayback.rawValue).call(["uid": uid]) { (result, error) in
                if let error = error {
                    print("Error skipping playback: \(error)")
                }
                self.playing = true
            }
        }
    }
    
    public func replayTrack() {
        // Attempt to skip to previous song locally
        if appRemote.isConnected {
            appRemote.playerAPI?.skip(toPrevious: { _, _ in
                self.playing = true
            })
        } else {
            // Else trigger backend function to skip to previous
            functions.httpsCallable(TriggerFunction.previousPlayback.rawValue).call(["uid": uid]) { (result, error) in
                if let error = error {
                    print("Error skipping to previous playback: \(error)")
                }
                self.playing = true
            }
        }
    }
    
    public func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            // Setup app remote
            appRemote.connectionParameters.accessToken = accessToken
            appRemote.connect()
            
            // Save access token for later
            userDefaults.set(accessToken, forKey: KeyValue.accessToken.rawValue)
            
            // Check if jobs were missed when player wasn't connected
            checkForJobs()
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("Error setting new access token: \(errorDescription)")
        }
    }
}
