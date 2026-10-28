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
    @State private var datos = DatosBoleta()

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
        VStack(alignment: .leading, spacing: 12) {
            Text("FORMULARIO").font(.headline)

            TextField("Sueldo básico", value: $datos.sueldoBasico, format: .number)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            TextField("Días laborados", value: $datos.diasLaborados, format: .number)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Picker("¿Tiene hijos?", selection: $datos.tieneHijos) {
                Text("No").tag(false)
                Text("Sí").tag(true)
            }
            .pickerStyle(.segmented)

            Picker("Sistema de pensión", selection: $datos.sistemaPension) {
                ForEach(SistemaPension.allCases) { sistema in
                    Text(sistema.rawValue).tag(sistema)
                }
            }
            .pickerStyle(.segmented)
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
