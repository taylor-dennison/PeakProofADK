//
//  PeakPRoofADK.swift
//
//
//  Created by Taylor Dennison on 11/23/22.
//

import SwiftUI

@main
struct PeakProofADK: App {
    
    let persistenceController = PersistenceController.shared
  
    var peaks = Peaks()

    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(peaks).environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
        
    }
}
