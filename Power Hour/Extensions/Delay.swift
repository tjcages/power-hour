//
//  Delay.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/11/22.
//

import SwiftUI

func delay(_ duration: Double, _ callback: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        callback()
    }
}

