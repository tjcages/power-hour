//
//  PullToRefresh.swift
//  Power Hour
//
//  Created by Tyler Cagle on 11/11/22.
//

import SwiftUI

struct PullToRefresh: View {
    
    var coordinateSpaceName: String = "pullToRefresh"
    var onRefresh: () -> Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 70) {
                Spacer()
                    .onAppear {
                        withAnimation {
                            self.needRefresh = true
                        }
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            withAnimation {
                                self.needRefresh = false
                            }
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                    .opacity(needRefresh ? 1 : 0)
                
                Spacer()
            }
        }
        .padding(.top, -50)
    }
}
