//
//  MainUI.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/15/21.
//

import SwiftUI

struct MainUI: View {
    
    @EnvironmentObject var arState: ARState
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                HStack {
                    if let image = arState.thumbnailImage {
                        if !arState.isThumbnailHidden {
                            SnapshotThumbnail(image: image)
                                .frame(width: 100, height: 200)
                                .aspectRatio(contentMode: .fit)
                                .padding(.leading, 10)
                        }
                    }
                    Spacer()
                }
                
                HStack {
                    MappingStatusView(statusLabel: arState.mappingStatus)
                        .frame(maxWidth: 100, alignment: .center)
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        print("DEBUG: reset tracking")
                        
                        arState.isResetButtonPressed = true
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    .padding(.trailing, 20)
                }
            }
            
            Spacer()
            
            SessionInfo(label: arState.sessionInfoLabel)
            SaveLoadButton()
        }
    }
}

struct MainUI_Previews: PreviewProvider {
    
    static var previews: some View {
        MainUI()
            .environmentObject(ARState())
            .environmentObject(SaveLoadData())
    }
}
