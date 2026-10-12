import SwiftUI
import Playgrounds

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Hello, world!")
                .tabItem {
                    Label("Pantalla 01", systemImage: "1.circle")
                }

            PantallaDos()
                .tabItem {
                    Label("Pantalla 02", systemImage: "2.circle")
                }
        }
    }
}

struct PantallaDos: View {
    var body: some View {
        Text("PANTALLA 02")
            .font(.largeTitle)
    }
}

#Preview {
    ContentView()
}
