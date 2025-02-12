//
//  ImmersiveView.swift
//  Overlap2D3D
//
//  Created by Marzia Pirozzi on 12/02/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ThreeDModelView: View {
    

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Model", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
        }
    }
}

