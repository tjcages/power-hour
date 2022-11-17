//
//  LoginPage.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/11/22.
//

import SwiftUI
import BetterSafariView

struct LoginPage: View {
    @EnvironmentObject var spotify: SpotifyController
    @ObservedObject var manager = MotionManager()
    
    @State var showSafari = false
    @State private var offsetAnimation = false
    
    var repeatingAnimation: Animation {
        Animation
            .easeInOut(duration: 15)
            .repeatForever()
    }
    
    let split = 5
    var items: [GridItem] = Array(repeating: .init(.flexible()), count: 6)
    var playlists: [String] = [
        "https://www.udiscovermusic.com/wp-content/uploads/2019/12/Post-Malone-Stoney-album-cover-820.jpg",
        "https://media.pitchfork.com/photos/6321de751dccce609e415e53/1:1/w_320,c_limit/Fred-Again-2022.jpg",
        "https://media.gq.com/photos/62686168e81af41464692a34/master/pass/GQ0522_Future_05.jpeg",
        "https://www.theglobeandmail.com/resizer/-2nub-HIMMjzvLyBK6qWJfgztyg=/600x0/filters:quality(80):format(jpeg)/arc-anglerfish-tgam-prod-tgam.s3.amazonaws.com/public/3YV2PTJAVFGCVJK5IC6RJYY6EA",
        "https://upload.wikimedia.org/wikipedia/en/3/35/Flume_-_Skin.png",
        "https://static1.squarespace.com/static/54b59d19e4b0adb56c393e4d/t/632da0bb1d510e171d57cd00/1663934652322/3RcOa6lY.jpeg",
        "https://upload.wikimedia.org/wikipedia/en/d/d3/JColeKOD.jpg",
        "https://upload.wikimedia.org/wikipedia/en/2/2a/2014ForestHillsDrive.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2GzYBtp9A52q7L7Y2yYqPA3I-cBf9uBp2gsLUpkNpUJ7R4aZJyFPJDZlJeRWwavCgEn0&usqp=CAU",
        "https://i.discogs.com/ADfqV-TiRSgyo0L418Emdar2bhJz_mxlt532JMWEjLc/rs:fit/g:sm/q:90/h:542/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTE0NzU0/MDM5LTE1ODEwMDYz/MjAtNzAwNy5qcGVn.jpeg",
        "https://upload.wikimedia.org/wikipedia/en/5/5e/Mac_Miller_-_Swimming.png",
        "https://upload.wikimedia.org/wikipedia/en/8/87/Doja_Cat_-_Hot_Pink.png",
        "https://media.pitchfork.com/photos/5b9685e6ec087f2ca7e0ae8b/1:1/w_600/lady%20lady.jpg",
        "https://media.pitchfork.com/photos/5fb557cb4cb304ce01ca1306/1:1/w_600/While%20The%20World%20Was%20Burning_SAINt%20JHN.jpg",
        "https://upload.wikimedia.org/wikipedia/en/2/2f/Billie_Eilish_-_Don%27t_Smile_at_Me.png",
        "https://images.complex.com/complex/images/c_fill,dpr_auto,f_auto,q_auto,w_1400/fl_lossy,pg_1/s0oc0ccezrznqld65o4i/khaled-album-art-2022?fimg-ssr-default",
        "https://i.scdn.co/image/ab67616d0000b273cd945b4e3de57edd28481a3f",
        "https://upload.wikimedia.org/wikipedia/en/f/f8/BS-FF-COVER.jpg",
        "https://images.squarespace-cdn.com/content/v1/5f7ce97df52b6220f573f715/1643921394778-I9ZS6CTWK9Y2AT6W676P/1efc5de2af228d2e49d91bd0dac4dc49.1000x1000x1.jpg",
        "https://m.media-amazon.com/images/I/41LVuIN8MlL._SY580_.jpg",
        "https://e.snmc.io/i/600/s/9c71643617d489c171dbaac21715d58b/5307748/cherub-year-of-the-caprese-cover-art.jpg",
        "https://erietigertimes.com/wp-content/uploads/2018/01/45A0EFF1-9C2F-4A94-9AB8-79ECA84100B3-900x900.jpeg",
        "https://upload.wikimedia.org/wikipedia/en/5/5d/3OH%213_-_Want.jpg",
        "https://m.media-amazon.com/images/I/81pu60697gL._SS500_.jpg",
        "https://upload.wikimedia.org/wikipedia/en/1/10/Childish_Gambino_-_Awaken%2C_My_Love%21.png",
        "https://images.complex.com/complex/images/c_fill,dpr_auto,f_auto,q_auto,w_1400/fl_lossy,pg_1/s0oc0ccezrznqld65o4i/khaled-album-art-2022?fimg-ssr-default",
        "https://i.scdn.co/image/ab67616d0000b273cd945b4e3de57edd28481a3f",
        "https://upload.wikimedia.org/wikipedia/en/f/f8/BS-FF-COVER.jpg",
        "https://images.squarespace-cdn.com/content/v1/5f7ce97df52b6220f573f715/1643921394778-I9ZS6CTWK9Y2AT6W676P/1efc5de2af228d2e49d91bd0dac4dc49.1000x1000x1.jpg",
        "https://m.media-amazon.com/images/I/41LVuIN8MlL._SY580_.jpg",
        "https://e.snmc.io/i/600/s/9c71643617d489c171dbaac21715d58b/5307748/cherub-year-of-the-caprese-cover-art.jpg",
        "https://erietigertimes.com/wp-content/uploads/2018/01/45A0EFF1-9C2F-4A94-9AB8-79ECA84100B3-900x900.jpeg",
        "https://upload.wikimedia.org/wikipedia/en/5/5d/3OH%213_-_Want.jpg",
        "https://m.media-amazon.com/images/I/81pu60697gL._SS500_.jpg",
        "https://upload.wikimedia.org/wikipedia/en/1/10/Childish_Gambino_-_Awaken%2C_My_Love%21.png",
        "https://images.complex.com/complex/images/c_fill,dpr_auto,f_auto,q_auto,w_1400/fl_lossy,pg_1/s0oc0ccezrznqld65o4i/khaled-album-art-2022?fimg-ssr-default",
        "https://i.scdn.co/image/ab67616d0000b273cd945b4e3de57edd28481a3f",
        "https://upload.wikimedia.org/wikipedia/en/f/f8/BS-FF-COVER.jpg",
        "https://images.squarespace-cdn.com/content/v1/5f7ce97df52b6220f573f715/1643921394778-I9ZS6CTWK9Y2AT6W676P/1efc5de2af228d2e49d91bd0dac4dc49.1000x1000x1.jpg",
        "https://m.media-amazon.com/images/I/41LVuIN8MlL._SY580_.jpg",
        "https://e.snmc.io/i/600/s/9c71643617d489c171dbaac21715d58b/5307748/cherub-year-of-the-caprese-cover-art.jpg",
        "https://erietigertimes.com/wp-content/uploads/2018/01/45A0EFF1-9C2F-4A94-9AB8-79ECA84100B3-900x900.jpeg",
        "https://upload.wikimedia.org/wikipedia/en/5/5d/3OH%213_-_Want.jpg",
        "https://m.media-amazon.com/images/I/81pu60697gL._SS500_.jpg",
        "https://upload.wikimedia.org/wikipedia/en/1/10/Childish_Gambino_-_Awaken%2C_My_Love%21.png",
    ].shuffled()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Group {
                    HStack() {
                        ForEach(playlists[0..<split], id: \.self) { playlist in
                            GyroPlaylistView(playlist)
                                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 50))
                        }
                    }
                    .offset(CGSize(width: offsetAnimation ? -.screenWidth * 0.5 : .screenWidth * 0.5, height: 0))
                    
                    HStack() {
                        ForEach(playlists[split..<(split * 2)], id: \.self) { playlist in
                            GyroPlaylistView(playlist)
                                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 50))
                        }
                    }
                    .offset(CGSize(width: offsetAnimation ? .screenWidth * 0.5 : -.screenWidth * 0.5, height: 0))
                    
                    HStack() {
                        ForEach(playlists[(split * 2)..<(split * 3)], id: \.self) { playlist in
                            GyroPlaylistView(playlist)
                                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 50))
                        }
                    }
                    .offset(CGSize(width: offsetAnimation ? -.screenWidth * 0.5 : .screenWidth * 0.5, height: 0))
                    
                    HStack() {
                        ForEach(playlists[(split * 3)..<(split * 4)], id: \.self) { playlist in
                            GyroPlaylistView(playlist)
                                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 50))
                        }
                    }
                    .offset(CGSize(width: offsetAnimation ? .screenWidth * 0.5 : -.screenWidth * 0.5, height: 0))
                    
                    HStack() {
                        ForEach(playlists[(split * 4)..<(split * 5)], id: \.self) { playlist in
                            GyroPlaylistView(playlist)
                                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 50))
                        }
                    }
                    .offset(CGSize(width: offsetAnimation ? -.screenWidth * 0.5 : .screenWidth * 0.5, height: 0))
                }
                .frame(width: .screenWidth * 2)
                .onAppear() {
                    delay(1) {
                        withAnimation(repeatingAnimation) { offsetAnimation = true }
                    }
                }
            }
            .reverseDim()
            .backgroundColor()
            
            VStack(spacing: .medium) {
                Spacer()
                
                Text("POWER HOUR 🍻")
                    .font(.largeTitleBrada)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, .medium)
                
                Text("Drink to your\nDIY power hour mix")
                    .font(.titleBrada)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                SpotifyButton() {
                    showSafari.toggle()
                }
                .padding(.top, .medium)
                
                Spacer()
                
                Text("You should prolly be like 21 to use this idk\n(or drink water instead)")
                    .font(.textBrada)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, .large)
            }
            .frame(maxWidth: .screenWidth)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .if(spotify.authenticationURL != nil, transform: { view in
            view.webAuthenticationSession(isPresented: $showSafari) {
                WebAuthenticationSession(
                    url: URL(string: spotify.authenticationURL!)!,
                    callbackURLScheme: "comtylerjpowerhour"
                ) { callbackURL, error in
                    let query: String?
                    if #available(iOS 16.0, *) {
                        query = callbackURL?.query()
                    } else {
                        query = callbackURL?.query
                    }
                    if let code = query?.components(separatedBy: "=").last {
                        spotify.grantUserAccess(code)
                    }
//                    if let url = callbackURL {
//                        spotify.setAccessToken(from: url)
//                    }
                }
                .prefersEphemeralWebBrowserSession(false)
            }
        })
    }
}
