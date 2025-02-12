import SwiftUI
import RealityKit
import RealityKitContent

struct TwoDModelView: View {
    var body: some View {
        RealityView { content in
            // Attempt to load the parent entity
            if let imageEntity = try? await Entity(named: "Image", in: realityKitContentBundle) {
                // Load the texture from the app bundle
                if let texture = try? TextureResource.load(named: "2DAsset") {
                    // Create a material using the texture
                    var material = SimpleMaterial()
                    material.color = .init(tint: .white, texture: .init(texture))
                    
                    // Find the 'Cube' entity within the loaded entity
                    if let cube = imageEntity.findEntity(named: "Cube") {
                        // Retrieve the ModelComponent of the Cube entity
                        if var modelComponent = cube.components[ModelComponent.self] {
                            // Assign the material to the Cube's ModelComponent
                            modelComponent.materials = [material]
                            cube.components[ModelComponent.self] = modelComponent
                        } else {
                            print("Failed to retrieve ModelComponent from Cube.")
                        }
                    } else {
                        print("Cube entity not found within Image entity.")
                    }
                } else {
                    print("Failed to load texture.")
                }
                
                // Add the entity to the RealityView content
                content.add(imageEntity)
            } else {
                print("Failed to load entity named 'Image'.")
            }
        }
    }
}
