//
//  ContentView.swift
//  Sistema_De_Pago_Boleta
//
//  Created by Rony Jhostin on 28/10/26.
//

import SwiftUI

/// Lienzo nivel 1 (docs/lienzo-nivel1.md): solo el acomodo visual.
/// Los TextField/Picker reales y el binding a Boleta.calcular van en los commits 8 y 9.
struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Boleta de ejemplo")
                    .font(.title2)
                    .bold()

                seccionFormulario

                Button("Calcular") {
                    // TODO: conectar con Boleta.calcular (commit 8-9)
                }
                .buttonStyle(.borderedProminent)

                seccionBoleta
            }
            .padding()
        }
    }

    private var seccionFormulario: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FORMULARIO").font(.headline)
            Text("Sueldo básico — [ ]")
            Text("Días laborados — [ ]")
            Text("¿Tiene hijos? — ( )")
            Text("Sistema de pensión — ( )")
        }
    }

    private var seccionBoleta: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("BOLETA").font(.headline)
            Text("REMUNERACIONES")
            Text("RETENCIONES / DESCUENTOS")
            Text("APORTACIONES DEL EMPLEADOR")
        }
    }
}

#Preview {
    ContentView()
}
