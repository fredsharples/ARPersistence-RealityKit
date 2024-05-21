//
//  CustomARView.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/17/21.
//
import SwiftUI
import RealityKit
import ARKit

class CustomARView: ARView {
    // Referring to @EnvironmentObject
    var saveLoadState: SaveLoadState
    var arState: ARState
    
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        return configuration
    }
    // MARK: - Init and setup
    
    init(frame frameRect: CGRect, saveLoadState: SaveLoadState, arState: ARState) {
        self.saveLoadState = saveLoadState
        self.arState = arState
        super.init(frame: frameRect)
    }

    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    func setup() {
        self.session.run(defaultConfiguration)
        self.session.delegate = self
        self.setupGestures()
        self.debugOptions = [ .showFeaturePoints ]
    }
    
    // MARK: - AR content
    var virtualObjectAnchor: ARAnchor?
    let virtualObjectAnchorName = "virtualObject"
   //var virtualObject = AssetModel(name: "teapot.usdz")
    var virtualObject = AssetModel(name: "narita")
   //var virtualObject = createModelEntity(<#T##self: CustomARView##CustomARView#>)
    //F#
    
    private func createModelEntity() -> ModelEntity {
        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.2, cornerRadius: 0.005)
        let material = createMaterialWithAlpha(alpha: 0.5)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.scale.z = 0.01
        
        let axis = simd_float3(1.0, 0.0, 0.0)
        let angle: Float = .pi / 2 // 90 degrees
        let quat = simd_quatf(angle: angle, axis: axis)
        model.transform.rotation = quat
        
        return model
    }
    private func createMaterialWithAlpha(alpha: CGFloat) -> SimpleMaterial {
        var material = SimpleMaterial()
        material.color = .init(tint: .white.withAlphaComponent(0.99), texture: .init(try! .load(named: "narita")))
        return material
    }
    
    
    // MARK: - AR session management
    var isRelocalizingMap = false
    
 
    // MARK: - Persistence: Saving and Loading
    let storedData = UserDefaults.standard
    let mapKey = "ar.worldmap"

    lazy var worldMapData: Data? = {
        storedData.data(forKey: mapKey)
    }()
    
    func resetTracking() {
        self.session.run(defaultConfiguration, options: [.resetTracking, .removeExistingAnchors])
        self.isRelocalizingMap = false
        self.virtualObjectAnchor = nil
        storedData.removeObject(forKey: "ar.worldmap")
    }
}
