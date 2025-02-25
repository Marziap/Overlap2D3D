import SwiftUI
import RealityKitContent

@main
struct Overlap2D3DApp: App {
    
    init() {
        RealityKitContent.ObjComponent.registerComponent()
        // Register custom RealityKit components once
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        ImmersiveSpace(id: "Empty") {
            EmptyView3D()
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
