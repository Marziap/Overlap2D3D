import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @State private var angle: Angle = .degrees(0)
    @Environment(\.openWindow) var openWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State var reality: RealityViewContent?
    
    var body: some View {
        
        // RealityView takes up all space
        RealityView { content in
            
            if let immersiveContentEntity = try? await Entity(named: "Empty", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
                self.reality = content
            }
            
        }.installGestures()
            .edgesIgnoringSafeArea(.all) // Make sure it fills the entire screen
        
        // 2D UI elements (HStack with Image and Buttons)
        HStack {
            Spacer()
            VStack {
                Image("2DAsset")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
                    .padding(.vertical, 70)
                
                Button {
                    print("open image")
                    Task {
                        // Add 2D image to immersive space
                        if let imageEntity = try? await Entity(named: "Image", in: realityKitContentBundle) {
                            if let texture = try? TextureResource.load(named: "2DAsset") {
                                var material = SimpleMaterial()
                                material.color = .init(tint: .white, texture: .init(texture))
                                
                                if let cube = imageEntity.findEntity(named: "Cube"),
                                   var modelComponent = cube.components[ModelComponent.self] {
                                    modelComponent.materials = [material]
                                    cube.components[ModelComponent.self] = modelComponent
                                    reality?.add(cube)
                                }
                            }
                        }
                    }
                } label: {
                    Text("Open Image")
                        .font(.title)
                }
            }
            Spacer()
            VStack {
                Model3D(named: "Model", bundle: realityKitContentBundle) { model in
                    switch model {
                    case .empty:
                        ProgressView()
                    case .success(let resolvedModel3D):
                        resolvedModel3D
                            .frame(height: 350)
                            .scaleEffect(0.4)
                            .rotation3DEffect(angle, axis: .x)
                            .rotation3DEffect(angle, axis: .y)
                            .animation(.linear(duration: 18).repeatForever(), value: angle)
                            .padding(.vertical, 70)
                            .onAppear {
                                angle = .degrees(359)
                            }
                    case .failure(let error):
                        Text(error.localizedDescription)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Button {
                    print("open model")
                    Task {
                        if let model = try? await Entity(named: "Model", in: realityKitContentBundle) {
                            if let capsule = model.findEntity(named: "Capsule") {
                                reality?.add(capsule)
                            }
                        }
                    }
                } label: {
                    Text("Open Model")
                        .font(.title)
                }
            }
            Spacer()
        }
        .padding() // Adjust padding as needed for UI elements
    }
    
}
