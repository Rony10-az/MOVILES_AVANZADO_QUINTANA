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
    @State private var pdfURL: URL?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Boleta Electrónica")
                        .font(.largeTitle.bold())
                    Text("Boleta de ejemplo")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if datos.modoReto {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(datos.nombreTrabajador)
                                .font(.callout.bold())
                            Text(datos.razonSocialEmpleador)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 6)
                    }
                }

                seccionFormulario

                Button("Calcular") {
                    if let error = datos.validarNivel1() ?? datos.validarNivel2() {
                        mensajeError = error
                        resultado = nil
                    } else {
                        mensajeError = nil
                        resultado = Boleta.calcular(datos)
                    }
                    pdfURL = nil
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)

                if let mensajeError {
                    Text(mensajeError)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                seccionBoleta

                if let resultado {
                    Button {
                        pdfURL = ExportadorPDF.generar(ReciboPDFView(resultado: resultado))
                    } label: {
                        Label("Generar boleta electrónica (PDF)", systemImage: "doc.richtext")
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    if let pdfURL {
                        ShareLink(item: pdfURL) {
                            Label("Compartir / Guardar PDF", systemImage: "square.and.arrow.up")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Formulario

    private var seccionFormulario: some View {
        encabezado("FORMULARIO") {
            tarjeta {
                VStack(spacing: 14) {
                    Toggle("Nivel 3 (reto)", isOn: $datos.modoReto)

                    if datos.modoReto {
                        filaCampo("Nombre del trabajador") {
                            TextField("Nombre", text: $datos.nombreTrabajador)
                                .multilineTextAlignment(.trailing)
                        }

                        filaCampo("Razón social") {
                            TextField("Empresa", text: $datos.razonSocialEmpleador)
                                .multilineTextAlignment(.trailing)
                        }

                        divisor()
                    }

                    filaCampo("Sueldo básico") {
                        TextField(
                            "0.00",
                            value: $datos.sueldoBasico,
                            format: .number.precision(.fractionLength(2)).locale(Locale(identifier: "en_US"))
                        )
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 120)
                    }

                    filaCampo("Días laborados") {
                        TextField("0", value: $datos.diasLaborados, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }

                    filaCampo("¿Tiene hijos?") {
                        Picker("", selection: $datos.tieneHijos) {
                            Text("No").tag(false)
                            Text("Sí").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 160)
                    }

                    filaCampo("Sistema de pensión") {
                        Picker("", selection: $datos.sistemaPension) {
                            ForEach(SistemaPension.allCases) { sistema in
                                Text(sistema.rawValue).tag(sistema)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 160)
                    }

                    if datos.sistemaPension == .afp {
                        filaCampo("AFP") {
                            Picker("", selection: $datos.afpElegida) {
                                ForEach(TipoAFP.allCases) { afp in
                                    Text(afp.rawValue).tag(afp)
                                }
                            }
                        }
                    }

                    filaCampo("Horas extra 25%") {
                        TextField("0", value: $datos.horasExtra25, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                    }

                    filaCampo("Horas extra 35%") {
                        TextField("0", value: $datos.horasExtra35, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                    }

                    filaCampo("Adelantos") {
                        TextField("0", value: $datos.adelantos, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
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
                    if datos.modoReto {
                        tarjeta(fondo: Color.orange.opacity(0.08)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("ONP vs. AFP (comparativo, informativo)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                HStack(spacing: 12) {
                                    comparativo("ONP (13%)", resultado?.onpComparativo)
                                    comparativo("AFP (total)", resultado?.afpComparativoTotal)
                                }
                            }
                        }
                    }

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
                            if datos.modoReto {
                                divisor(color: Color.red.opacity(0.2))
                                fila("Renta 5ta categoría", resultado?.rentaQuintaMensual, color: .red)
                            }
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
    private func filaCampo<Contenido: View>(
        _ etiqueta: String, @ViewBuilder contenido: () -> Contenido
    ) -> some View {
        HStack {
            Text(etiqueta)
            Spacer()
            contenido()
        }
    }

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

    private func comparativo(_ titulo: String, _ valor: Double?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(monto(valor ?? 0))
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
