//
//  SpotifyNotifications.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/15/22.
//

import SwiftUI
import FirebaseMessaging

extension SpotifyController: UNUserNotificationCenterDelegate, MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
            if let error = error {
                return
            } else if let token = token {
                guard let uid = self.uid else { return }
                return self.store.collection(self.accessPath).document(uid).setData(["fcmToken": token], merge: true)
            }
        }
    }
}
