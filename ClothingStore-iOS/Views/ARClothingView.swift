////
////  ARClothingView.swift
////  ClothingStore-iOS
////
////  Created by COBSCCOMPY4231P-15 on 2024-11-10.
////
//
//import Foundation
//import SwiftUI
//import RealityKit
//import ARKit
//
//struct ARClothingView: View {
//    var product: Cloth
//    
//    var body: some View {
//        ARViewContainer(product: product)
//            .edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct ARViewContainer: UIViewRepresentable {
//    var product: Cloth
//    
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        
//        // Configure AR session
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal]
//        arView.session.run(config)
//        
//        // Load and place 3D model (assuming product.modelURL points to the model)
//        if let modelEntity = try? loadModelEntity(from: product.modelURL) {
//            let anchorEntity = AnchorEntity(plane: .horizontal)
//            anchorEntity.addChild(modelEntity)
//            arView.scene.addAnchor(anchorEntity)
//        }
//        
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {}
//
//    func loadModelEntity(from url: String) throws -> ModelEntity {
//        let modelURL = URL(string: url)!
//        let modelEntity = try ModelEntity.loadModel(contentsOf: modelURL)
//        modelEntity.scale = SIMD3(repeating: 0.1) // Adjust scale as needed
//        return modelEntity
//    }
//}
