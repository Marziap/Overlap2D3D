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
    @State var reality: RealityViewContent?
    @State var image: Entity = Entity()
    @State var canMoveImage: Bool = true
    
    var body: some View {
        // RealityView for immersive content
        RealityView { content, attachments in
            // Add the immersive content to the scene
            if let immersiveContentEntity = try? await Entity(named: "Empty", in: realityKitContentBundle) {
                //immersiveContentEntity.transform.scale = .init(x: 2, y: 1, z: 1)
                content.add(immersiveContentEntity)
                self.reality = content
                
                
                //3. Retrieve the attachment with the "GlassCubeLabel" identifier as an entity.
                if let awindowAttachment = attachments.entity(for: "WindowUI") {
                    //4. Position the Attachment and add it to the RealityViewContent
                    awindowAttachment.position = [0, 0, 0]
                    immersiveContentEntity.addChild(awindowAttachment)
                }
                
            }
        }update: { content, attachments  in
            
            if(!canMoveImage){
                image.components[ObjComponent.self]?.canDrag = false
                image.components[ObjComponent.self]?.canRotate = false
                image.components[ObjComponent.self]?.canScale = false
                image.components[ObjComponent.self]?.pivotOnDrag = false
                image.components[ObjComponent.self]?.preserveOrientationOnPivotDrag = false
            }else{
                image.components[ObjComponent.self]?.canDrag = true
                image.components[ObjComponent.self]?.canRotate = true
                image.components[ObjComponent.self]?.canScale = true
                image.components[ObjComponent.self]?.pivotOnDrag = true
                image.components[ObjComponent.self]?.preserveOrientationOnPivotDrag = true
            }
            
        }
        placeholder: {
            ProgressView()
        } attachments: {
            //1. Create the Attachment
            Attachment(id: "WindowUI") {
                // 2D UI overlay on top of the immersive space
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image("2DAsset")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350)
                                .padding(.vertical, 70)
                            
                            Button {
                                print("Open Image")
                                Task {
                                    // Add 2D image to the immersive space
                                    if let imageEntity = try? await Entity(named: "Image", in: realityKitContentBundle) {
                                        
                                        if let texture = try? TextureResource.load(named: "2DAsset") {
                                            var material = SimpleMaterial()
                                            material.color = .init(tint: .white, texture: .init(texture))
                                            
                                            if let cube = imageEntity.findEntity(named: "Cube"),
                                               var modelComponent = cube.components[ModelComponent.self] {
                                                modelComponent.materials = [material]
                                                cube.components[ModelComponent.self] = modelComponent
                                                self.image = cube
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
                                    //                                        .rotation3DEffect(angle, axis: (x: 1, y: 0, z: 0))
                                    //                                        .rotation3DEffect(angle, axis: (x: 0, y: 1, z: 0))
                                    //                                        .animation(.linear(duration: 18).repeatForever(), value: angle)
                                        .padding(.vertical, 70)
                                    //                                        .onAppear {
                                    //                                            angle = .degrees(359)
                                    //                                        }
                                case .failure(let error):
                                    Text(error.localizedDescription)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            Button {
                                print("Open Model")
                                Task {
                                    if let model = try? await Entity(named: "Model", in: realityKitContentBundle) {
                                        if let capsule = model.findEntity(named: "ImageToStl_com_iso") {
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
                    
                    Spacer()
                    
                    Toggle(isOn: $canMoveImage) {
                        Text("Can Move Image")
                    }.toggleStyle(.button)
                    
                    Spacer()
                }
            }
        }.installGestures()
            .gesture(SpatialTapGesture().onEnded({ value in
                Task {
                    // Get the tapped location in world space
                    
                    let tapLocationWorld = value.location3D
                    
                    // Convert Point3D to SIMD3<Float>
                    let worldPosition = SIMD3<Float>(Float(tapLocationWorld.x), Float(tapLocationWorld.y), Float(tapLocationWorld.z))
                    
                    // Convert the world position to the entity's local space
                    let tapLocationLocal = image.convert(position: worldPosition, from: nil)
                    
                    // Log the results
                    //                    print("Tapped location in world space: \(tapLocationWorld)")
                    print("Tapped location in entity's local space: \(tapLocationLocal)")
                    
                    
                    if let sphereScene = try? await Entity(named: "SphereScene", in: realityKitContentBundle) {
                        
                        if let sphere = sphereScene.findEntity(named: "Sphere"){
                            sphere.position = tapLocationLocal
                            image.addChild(sphere, preservingWorldTransform: false)
                            print("sphere added")
                        }
                        
                        
                    }
                    
                    
                    
                }
                
            }))
        
        
        
        
    }
}
