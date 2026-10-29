//
//  ContentView.swift
//  Sistema_De_Pago_Boleta
//
//  Created by Rony Jhostin on 28/10/26.
//

import SwiftUI

/// UI de la boleta con tarjetas por sección, siguiendo el lienzo de docs/.
struct ContentView: View {
    @State private var datos = DatosBoleta()
    @State private var resultado: ResultadoBoleta?
    @State private var mensajeError: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Boleta de ejemplo")
                    .font(.title2)
                    .bold()

                seccionFormulario

                Button("Calcular") {
                    if let error = datos.validarNivel1() ?? datos.validarNivel2() {
                        mensajeError = error
                        resultado = nil
                    } else {
                        mensajeError = nil
                        resultado = Boleta.calcular(datos)
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)

                if let mensajeError {
                    Text(mensajeError)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                seccionBoleta
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Formulario

    private var seccionFormulario: some View {
        encabezado("FORMULARIO") {
            tarjeta {
                VStack(spacing: 12) {
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

                    if datos.sistemaPension == .afp {
                        Picker("AFP", selection: $datos.afpElegida) {
                            ForEach(TipoAFP.allCases) { afp in
                                Text(afp.rawValue).tag(afp)
                            }
                        }
                    }

                    TextField("Horas extra 25%", value: $datos.horasExtra25, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)

                    TextField("Horas extra 35%", value: $datos.horasExtra35, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)

                    TextField("Adelantos", value: $datos.adelantos, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }

    // MARK: - Boleta

    private var seccionBoleta: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("BOLETA")
                .font(.title3)
                .bold()

            encabezado("REMUNERACIONES") {
                tarjeta {
                    VStack(spacing: 0) {
                        fila("Sueldo computable", resultado?.sueldoComputable)
                        divisor()
                        fila("Asignación familiar", resultado?.asignacionFamiliar)
                        divisor()
                        fila("Horas extra 25%", resultado?.horasExtra25Monto)
                        divisor()
                        fila("Horas extra 35%", resultado?.horasExtra35Monto)
                        divisor()
                        fila("Total remuneraciones", resultado?.totalRemuneraciones, destacado: true)
                    }
                }
            }

            encabezado("RETENCIONES / DESCUENTOS") {
                VStack(spacing: 10) {
                    tarjeta(fondo: Color.red.opacity(0.08)) {
                        VStack(spacing: 0) {
                            fila("ONP", resultado?.onp, color: .red)
                            divisor(color: Color.red.opacity(0.2))
                            fila("AFP fondo", resultado?.afpFondo, color: .red)
                            divisor(color: Color.red.opacity(0.2))
                            fila("AFP comisión", resultado?.afpComision, color: .red)
                            divisor(color: Color.red.opacity(0.2))
                            fila("AFP seguro", resultado?.afpSeguro, color: .red)
                            divisor(color: Color.red.opacity(0.2))
                            fila("Adelantos", resultado?.adelantos, color: .red)
                            divisor(color: Color.red.opacity(0.2))
                            fila("Total descuentos", resultado?.totalDescuentos, destacado: true, color: .red)
                        }
                    }

                    tarjeta(fondo: Color.blue.opacity(0.1)) {
                        HStack {
                            Text("NETO A PAGAR")
                                .font(.headline)
                                .foregroundStyle(.blue)
                            Spacer()
                            Text(monto(resultado?.netoAPagar ?? 0))
                                .font(.title3.bold())
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }

            encabezado("APORTACIONES DEL EMPLEADOR") {
                tarjeta {
                    fila("EsSalud (9%)", resultado?.esSaludEmpleador)
                }
            }
        }
    }

    // MARK: - Helpers visuales

    @ViewBuilder
    private func encabezado<Contenido: View>(
        _ titulo: String, @ViewBuilder contenido: () -> Contenido
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.caption)
                .foregroundStyle(.secondary)
            contenido()
        }
    }

    @ViewBuilder
    private func tarjeta<Contenido: View>(
        fondo: Color = Color(.secondarySystemGroupedBackground),
        @ViewBuilder contenido: () -> Contenido
    ) -> some View {
        contenido()
            .padding()
            .background(fondo)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func divisor(color: Color = Color(.separator)) -> some View {
        Rectangle()
            .fill(color)
            .frame(height: 1)
    }

    private func fila(_ etiqueta: String, _ valor: Double?, destacado: Bool = false, color: Color = .primary) -> some View {
        HStack {
            Text(etiqueta)
            Spacer()
            Text(monto(valor ?? 0))
        }
        .padding(.vertical, 6)
        .fontWeight(destacado ? .bold : .regular)
        .foregroundStyle(color)
    }

    private func monto(_ valor: Double) -> String {
        String(format: "%.2f", valor)
    }
}

#Preview {
    ContentView()
}
