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
    var virtualObjectAnchorName = "virtualObject"
    var virtualObject = AssetModel(name: "sticker")

    
    // MARK: - AR session management
    var isRelocalizingMap = false
    
 
    // MARK: - Persistence: Saving and Loading
    let storedData = UserDefaults.standard
    let mapKey = "sticker"

    lazy var worldMapData: Data? = {
        storedData.data(forKey: mapKey)
    }()
    
    func resetTracking() {
        self.session.run(defaultConfiguration, options: [.resetTracking, .removeExistingAnchors])
        self.isRelocalizingMap = false
        self.virtualObjectAnchor = nil
    }
    
    func resetMemory(){
        
        resetTracking();
       // let dictionary = storedData.dictionaryRepresentation()
        printUserDefaults(forKeys: ["sticker"])
      
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        
        
//        dictionary.keys.forEach { key in
//            storedData.removeObject(forKey: key)
//        }
//
//        // Synchronize to make sure all data is removed immediately
//        storedData.synchronize()
//        _ = storedData.dictionaryRepresentation()
        //print("After deletion: \(updatedDictionary)")
        printUserDefaults(forKeys: ["sticker"])
    }
    
    func printUserDefaults(forKeys keys: [String]) {
        let defaults = UserDefaults.standard
        for key in keys {
            if let value = defaults.object(forKey: key) {
                print("STORED KEY VALUE\(key): \(value)")
            } else {
                print("\(key): nil")
            }
        }
    }
}
