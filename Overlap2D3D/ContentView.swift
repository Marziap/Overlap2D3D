//
//  ContentView.swift
//  Overlap2D3D
//
//  Created by Marzia Pirozzi on 12/02/25.
//

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
                
        RealityView { content in
            
            if let immersiveContentEntity = try? await Entity(named: "Empty", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
                
                self.reality = content
            }
        }
        
                HStack {
                    Spacer()
                    VStack{
                        Image("2DAsset")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                            .padding(.vertical, 70)
                        Button {
                            print("open image")
                            Task{
                                //add 2DModel to immersive space
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
                                    reality!.add(imageEntity)
                                } else {
                                    print("Failed to load entity named 'Image'.")
                                }
                            }
                            
                        } label: {
                            Text("Open Image")
                                .font(.title)
                        }
                    }
                    
                    Spacer()
                    
                    VStack{
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
                            Task{
                                if let image = try? await Entity(named: "Model", in: realityKitContentBundle) {
                                    reality!.add(image)
                                }
                                //add 3Dmodel to immersive space
                                
                            }
                            
                        } label: {
                            Text("Open Model")
                                .font(.title)
                        }

                        
                    }
                    Spacer()
                }

    }
}

