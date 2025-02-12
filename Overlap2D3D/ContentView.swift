//
//  ContentView.swift
//  Overlap2D3D
//
//  Created by Marzia Pirozzi on 12/02/25.
//

import SwiftUI
import RealityKit

struct ContentView: View {

    var body: some View {
        VStack {
            ToggleImmersiveSpaceButton()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
