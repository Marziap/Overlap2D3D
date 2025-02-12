//
//  Overlap2D3DApp.swift
//  Overlap2D3D
//
//  Created by Marzia Pirozzi on 12/02/25.
//

import SwiftUI
import RealityKitContent

@main
struct Overlap2D3DApp: App {
    
    
    var body: some Scene {
        WindowGroup {

            ContentView()
            }
        
//        WindowGroup(id: "2DModelView") {
//            TwoDModelView()
//        }
//        .windowStyle(.volumetric)
        
//        WindowGroup(id: "3DModelView") {
//            ThreeDModelView()
//        }
//        .windowStyle(.volumetric)
        
        ImmersiveSpace(id: "Empty") {
            Emptyy()
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
//        ImmersiveSpace(id: "3DModelView") {
//            ThreeDModelView()
//        }
//        .immersionStyle(selection: .constant(.mixed), in: .mixed)
//        
//        ImmersiveSpace(id: "2DModelView") {
//            TwoDModelView()
//        }
//        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
    }
}
