//
//  ImmersiveView.swift
//  Overlap2D3D
//
//  Created by Marzia Pirozzi on 12/02/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct EmptyView3D: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Empty", in: realityKitContentBundle) {
                //immersiveContentEntity.transform.scale = .init(x: 1, y: 1, z: 1)
                content.add(immersiveContentEntity)
            }
        }
        .installGestures()
        .edgesIgnoringSafeArea(.all) // Make sure the 3D view fills the entire screen
        
    }
}
