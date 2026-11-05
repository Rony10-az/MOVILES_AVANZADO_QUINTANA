//
//  Apple_lab11_02_UIKIT_SwiftDataApp.swift
//  Apple_lab11_02_UIKIT_SwiftData
//
//  Created by Rony Jhostin on 5/11/26.
//

import SwiftUI
import SwiftData

@main // Punto de entrada principal de la aplicación
struct Apple_lab11_02_UIKIT_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() // Vista inicial: la lista de alumnos
                // Contenedor persistente para toda la app:
                // los datos se guardan en disco y no se borran al cerrar la app
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
