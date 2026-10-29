import SwiftUI

/// Layout imprimible de la boleta (tamaño carta), para exportar a PDF.
struct ReciboPDFView: View {
    let resultado: ResultadoBoleta
    let fecha: Date = Date()

    private var fechaTexto: String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.locale = Locale(identifier: "es_PE")
        return f.string(from: fecha)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("BOLETA ELECTRÓNICA")
                    .font(.largeTitle.bold())
                Text("Boleta de ejemplo")
                    .font(.subheadline)
                Text(fechaTexto)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Divider()

            bloque("REMUNERACIONES") {
                fila("Sueldo computable", resultado.sueldoComputable)
                fila("Asignación familiar", resultado.asignacionFamiliar)
                fila("Horas extra 25%", resultado.horasExtra25Monto)
                fila("Horas extra 35%", resultado.horasExtra35Monto)
                fila("Total remuneraciones", resultado.totalRemuneraciones, destacado: true)
            }

            bloque("RETENCIONES / DESCUENTOS") {
                fila("ONP", resultado.onp)
                fila("AFP fondo", resultado.afpFondo)
                fila("AFP comisión", resultado.afpComision)
                fila("AFP seguro", resultado.afpSeguro)
                fila("Adelantos", resultado.adelantos)
                fila("Total descuentos", resultado.totalDescuentos, destacado: true)
            }

            HStack {
                Text("NETO A PAGAR").font(.title3.bold())
                Spacer()
                Text(monto(resultado.netoAPagar)).font(.title3.bold())
            }
            .padding()
            .background(Color.blue.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            bloque("APORTACIONES DEL EMPLEADOR") {
                fila("EsSalud (9%)", resultado.esSaludEmpleador)
            }

            Spacer()
        }
        .padding(32)
        .frame(width: 612, height: 792, alignment: .top)
        .background(Color.white)
        .foregroundStyle(Color.black)
    }

    @ViewBuilder
    private func bloque<Contenido: View>(_ titulo: String, @ViewBuilder contenido: () -> Contenido) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo).font(.headline)
            contenido()
        }
    }

    private func fila(_ etiqueta: String, _ valor: Double, destacado: Bool = false) -> some View {
        HStack {
            Text(etiqueta)
            Spacer()
            Text(monto(valor))
        }
        .fontWeight(destacado ? .bold : .regular)
    }

    private func monto(_ valor: Double) -> String {
        String(format: "%.2f", valor)
    }
}

#Preview {
    ReciboPDFView(resultado: Boleta.calcular(DatosBoleta()))
}
