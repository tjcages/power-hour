//
//  BaseEncoding.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/11/22.
//

import SwiftUI

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
