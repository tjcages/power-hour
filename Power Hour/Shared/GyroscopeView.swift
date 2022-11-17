//
//  GyroscopeView.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/11/22.
//

import SwiftUI
import CoreMotion

struct ParallaxMotionModifier: ViewModifier {
    @ObservedObject var manager: MotionManager
    
    var magnitude: Double
    
    func body(content: Content) -> some View {
        content
            .offset(x: CGFloat(manager.roll * magnitude), y: CGFloat(manager.pitch * magnitude))
            .scaleEffect(1 - abs(manager.roll / 40) - abs(manager.pitch / 80))
    }
}

class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    
    private var manager: CMMotionManager

    init() {
        manager = CMMotionManager()
        manager.deviceMotionUpdateInterval = 1/60
        manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }

            if let motionData = motionData {
                withAnimation(Animation.linear(duration: 0.3)) {
                    self.pitch = motionData.attitude.pitch
                    self.roll = motionData.attitude.roll
                }
            }
        }

    }
}
