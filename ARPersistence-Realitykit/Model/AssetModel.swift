//
//  ModelAsset.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/16/21.
//

import UIKit
import RealityKit
import Combine

class AssetModel {
    var name: String
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(name: String) {
        self.name = name
        self.modelEntity = createModelEntity()
    }
    
    private func createModelEntity() -> ModelEntity {
        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.2, cornerRadius: 0)
        let material = createMaterialWithAlpha(alpha: 0.5)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.scale.z = 0.001
        
        let axis = simd_float3(1.0, 0.0, 0.0)
        let angle: Float = .pi / 2 // 90 degrees
        let quat = simd_quatf(angle: angle, axis: axis)
        model.transform.rotation = quat
        model.name = "sticker"
        
        return model
    }
    
    func getRandomImage() -> String? {
        let stringsArray = ["narita", "udonnou","taimi","801chan","yurukyara","seacattle","bluejay","seamonster","sorajiro","salmonsushi","wapuupin"]
        return stringsArray.randomElement()
    }
    
    private func createMaterialWithAlpha(alpha: CGFloat) -> SimpleMaterial {
        let randomString = getRandomImage()
        var material = SimpleMaterial()
        material.color = .init(tint: .white.withAlphaComponent(0.99), texture: .init(try! .load(named: randomString!)))
        
        return material
    }
}
