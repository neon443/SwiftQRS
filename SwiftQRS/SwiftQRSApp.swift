//
//  SwiftQRSApp.swift
//  SwiftQRS
//
//  Created by Nihaal Sharma on 22/12/2024.
//

import SwiftUI

@main
struct SwiftQRSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
