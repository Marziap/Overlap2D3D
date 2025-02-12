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
    
    init() {
        RealityKitContent.ObjComponent.registerComponent()
        //call this once to register the component
    }
    
    var body: some Scene {
        WindowGroup {

            ContentView()
            }
        
        ImmersiveSpace(id: "Empty") {
            Emptyy()
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
    }
}
