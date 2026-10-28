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
    @State private var resultado: ResultadoBoleta?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Boleta de ejemplo")
                    .font(.title2)
                    .bold()

                seccionFormulario

                Button("Calcular") {
                    resultado = Boleta.calcular(datos)
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
        VStack(alignment: .leading, spacing: 16) {
            Text("BOLETA").font(.headline)

            bloque(titulo: "REMUNERACIONES") {
                fila("Sueldo computable", resultado?.sueldoComputable)
                fila("Asignación familiar", resultado?.asignacionFamiliar)
                fila("Total remuneraciones", resultado?.totalRemuneraciones, destacado: true)
            }

            bloque(titulo: "RETENCIONES / DESCUENTOS") {
                fila("ONP", resultado?.onp)
                fila("Total descuentos", resultado?.totalDescuentos)
                fila("NETO A PAGAR", resultado?.netoAPagar, destacado: true)
            }

            bloque(titulo: "APORTACIONES DEL EMPLEADOR") {
                fila("EsSalud (9%)", resultado?.esSaludEmpleador)
            }
        }
    }

    @ViewBuilder
    private func bloque<Contenido: View>(titulo: String, @ViewBuilder contenido: () -> Contenido) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo).font(.subheadline).bold()
            contenido()
        }
    }

    private func fila(_ etiqueta: String, _ valor: Double?, destacado: Bool = false) -> some View {
        HStack {
            Text(etiqueta)
            Spacer()
            Text(monto(valor ?? 0))
        }
        .fontWeight(destacado ? .bold : .regular)
    }

    private func monto(_ valor: Double) -> String {
        String(format: "%.2f", valor)
    }
}

#Preview {
    ContentView()
}
