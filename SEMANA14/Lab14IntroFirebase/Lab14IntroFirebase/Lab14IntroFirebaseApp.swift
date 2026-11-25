//
//  Lab14IntroFirebaseApp.swift
//  Lab14IntroFirebase
//
//  Created by Rony Jhostin on 19/11/26.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct Lab14IntroFirebaseApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
