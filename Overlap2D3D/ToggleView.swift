//
//  ToggleView.swift
//  Overlap2D3D
//
//  Created by Marzia Pirozzi on 25/02/25.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct ToggleView: View {
    
    @State var image: Entity = Entity()
    @State var model: Entity = Entity()
    @State var imageToggle: Bool = true
    
    var body: some View {
        
        RealityView { content, attachments in
            // Add the initial RealityKit content
            if let foto = try? await Entity(named: "Image", in: realityKitContentBundle) {
                image = foto
                
                if(imageToggle == false){
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
            
            if let modello = try? await Entity(named: "Model", in: realityKitContentBundle) {
                model = modello
            }
            
            //3. Retrieve the attachment with the "GlassCubeLabel" identifier as an entity.
            if let awindowAttachment = attachments.entity(for: "Window") {
                //4. Position the Attachment and add it to the RealityViewContent
                awindowAttachment.position = [0, 0, 0]
                content.add(awindowAttachment)
            }
            
        }placeholder: {
            ProgressView()
        } attachments: {
            //1. Create the Attachment
            Attachment(id: "Window") {
                VStack {
                    
                    Text("Settings").font(.title)
                    Toggle("Can move image", isOn: $imageToggle)
                    
                }.padding()
                .glassBackgroundEffect()
            }
        }
    }
    
}



#Preview {
    ToggleView()
}
