import SwiftUI

struct PantallaDosView: View {
    var body: some View {
        Text("PANTALLA 02")
            .font(.largeTitle)
            .navigationTitle("Pantalla 02")
    }
}

#Preview {
    NavigationStack {
        PantallaDosView()
    }
}
