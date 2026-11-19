//
//  ResumenViewController.swift
//  VentasTecsup
//
//  Pantalla A9 (nivel Reto): indicadores, gráfico de 7 días,
//  ranking de vendedores y stock bajo, con fetch requests.
//  Estructura (scroll, tarjetas) definida en Main.storyboard.
//

import UIKit
import CoreData

class ResumenViewController: UIViewController {

    @IBOutlet private weak var saludoLabel: UILabel!
    @IBOutlet private weak var vendidoHoyLabel: UILabel!
    @IBOutlet private weak var igvMesLabel: UILabel!
    @IBOutlet private weak var graficoStack: UIStackView!
    @IBOutlet private weak var rankingStack: UIStackView!
    @IBOutlet private weak var stockBajoStack: UIStackView!

    @IBOutlet private weak var tarjetaHoyView: UIView!
    @IBOutlet private weak var tarjetaMesView: UIView!
    @IBOutlet private weak var tarjetaGraficoView: UIView!
    @IBOutlet private weak var tarjetaRankingView: UIView!
    @IBOutlet private weak var tarjetaStockView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resumen"
        saludoLabel.font = .boldSystemFont(ofSize: 24)
        vendidoHoyLabel.font = .boldSystemFont(ofSize: 22)
        vendidoHoyLabel.textColor = .tecsupAzul
        igvMesLabel.font = .boldSystemFont(ofSize: 22)
        igvMesLabel.textColor = .tecsupVerde

        for tarjeta in [tarjetaHoyView, tarjetaMesView, tarjetaGraficoView, tarjetaRankingView, tarjetaStockView] {
            tarjeta?.backgroundColor = .secondarySystemGroupedBackground
            tarjeta?.layer.cornerRadius = 14
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarDatos()
    }

    // MARK: - Datos

    private func cargarDatos() {
        let contexto = SesionUsuario.compartida.contexto
        saludoLabel.text = "Hola, \(SesionUsuario.compartida.usuarioActual?.nombre ?? "")"

        let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
        solicitud.predicate = NSPredicate(format: "anulada == NO")
        let ventas = (try? contexto.fetch(solicitud)) ?? []

        let calendario = Calendar.current
        let deHoy = ventas.filter { $0.fecha.map { calendario.isDateInToday($0) } ?? false }
        let delMes = ventas.filter { venta in
            guard let fecha = venta.fecha else { return false }
            return calendario.isDate(fecha, equalTo: Date(), toGranularity: .month)
        }
        vendidoHoyLabel.text = deHoy.reduce(0) { $0 + $1.total }.comoMoneda
        igvMesLabel.text = delMes.reduce(0) { $0 + $1.igv }.comoMoneda

        actualizarGrafico(ventas: ventas, calendario: calendario)
        actualizarRanking(ventas: delMes)
        actualizarStockBajo(contexto: contexto)
    }

    /// Gráfico de barras con el total vendido cada uno de los últimos 7 días.
    private func actualizarGrafico(ventas: [Venta], calendario: Calendar) {
        graficoStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        var totalesPorDia: [(etiqueta: String, total: Double)] = []
        let formateadorDia = DateFormatter()
        formateadorDia.setLocalizedDateFormatFromTemplate("EEEEE")

        for desplazamiento in stride(from: 6, through: 0, by: -1) {
            guard let dia = calendario.date(byAdding: .day, value: -desplazamiento, to: Date()) else { continue }
            let totalDelDia = ventas
                .filter { $0.fecha.map { calendario.isDate($0, inSameDayAs: dia) } ?? false }
                .reduce(0) { $0 + $1.total }
            totalesPorDia.append((formateadorDia.string(from: dia).uppercased(), totalDelDia))
        }

        let maximo = max(totalesPorDia.map(\.total).max() ?? 0, 1)
        for (etiqueta, total) in totalesPorDia {
            let barra = UIView()
            barra.backgroundColor = total > 0 ? .tecsupAzul : .systemGray5
            barra.layer.cornerRadius = 4
            let alturaBarra = max(4, CGFloat(total / maximo) * 80)
            barra.heightAnchor.constraint(equalToConstant: alturaBarra).isActive = true

            let etiquetaLabel = UILabel()
            etiquetaLabel.text = etiqueta
            etiquetaLabel.font = .systemFont(ofSize: 10)
            etiquetaLabel.textAlignment = .center
            etiquetaLabel.textColor = .secondaryLabel

            let columna = UIStackView(arrangedSubviews: [barra, etiquetaLabel])
            columna.axis = .vertical
            columna.spacing = 4
            columna.alignment = .fill
            graficoStack.addArrangedSubview(columna)
        }
    }

    /// Lista de vendedores ordenada por total vendido en el mes, con una barra proporcional.
    private func actualizarRanking(ventas: [Venta]) {
        rankingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        var totalesPorVendedor: [String: Double] = [:]
        for venta in ventas {
            let nombre = venta.vendedor?.nombre ?? "—"
            totalesPorVendedor[nombre, default: 0] += venta.total
        }
        let orden = totalesPorVendedor.sorted { $0.value > $1.value }

        if orden.isEmpty {
            rankingStack.addArrangedSubview(etiquetaVacia("Todavía no hay ventas este mes."))
            return
        }

        let maximo = orden.first?.value ?? 1
        for (nombre, total) in orden {
            let nombreLabel = UILabel()
            nombreLabel.text = nombre
            nombreLabel.font = .systemFont(ofSize: 14)

            let totalLabel = UILabel()
            totalLabel.text = total.comoMoneda
            totalLabel.font = .boldSystemFont(ofSize: 14)
            totalLabel.textAlignment = .right

            let filaTexto = UIStackView(arrangedSubviews: [nombreLabel, totalLabel])
            filaTexto.axis = .horizontal

            let fondoBarra = UIView()
            fondoBarra.backgroundColor = .systemGray5
            fondoBarra.layer.cornerRadius = 4
            fondoBarra.heightAnchor.constraint(equalToConstant: 8).isActive = true

            let progreso = UIView()
            progreso.backgroundColor = .tecsupAzul
            progreso.layer.cornerRadius = 4
            progreso.translatesAutoresizingMaskIntoConstraints = false
            fondoBarra.addSubview(progreso)
            let proporcion = maximo > 0 ? CGFloat(total / maximo) : 0
            NSLayoutConstraint.activate([
                progreso.leadingAnchor.constraint(equalTo: fondoBarra.leadingAnchor),
                progreso.topAnchor.constraint(equalTo: fondoBarra.topAnchor),
                progreso.bottomAnchor.constraint(equalTo: fondoBarra.bottomAnchor),
                progreso.widthAnchor.constraint(equalTo: fondoBarra.widthAnchor, multiplier: max(0.03, proporcion))
            ])

            let columna = UIStackView(arrangedSubviews: [filaTexto, fondoBarra])
            columna.axis = .vertical
            columna.spacing = 4
            rankingStack.addArrangedSubview(columna)
        }
    }

    /// Productos con 5 unidades de stock o menos.
    private func actualizarStockBajo(contexto: NSManagedObjectContext) {
        stockBajoStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let solicitud: NSFetchRequest<Producto> = Producto.fetchRequest()
        solicitud.predicate = NSPredicate(format: "stock <= 5")
        solicitud.sortDescriptors = [NSSortDescriptor(key: "stock", ascending: true)]
        let productos = (try? contexto.fetch(solicitud)) ?? []

        if productos.isEmpty {
            stockBajoStack.addArrangedSubview(etiquetaVacia("Ningún producto con stock bajo."))
            return
        }

        for producto in productos {
            let nombreLabel = UILabel()
            nombreLabel.text = "\(producto.nombre ?? "") · \(producto.stock) u."
            nombreLabel.font = .systemFont(ofSize: 14)

            let insignia = UILabel()
            insignia.text = "  Reponer  "
            insignia.font = .boldSystemFont(ofSize: 11)
            insignia.textColor = .white
            insignia.backgroundColor = .tecsupRojo
            insignia.layer.cornerRadius = 9
            insignia.layer.masksToBounds = true

            let fila = UIStackView(arrangedSubviews: [nombreLabel, UIView(), insignia])
            fila.axis = .horizontal
            fila.alignment = .center
            stockBajoStack.addArrangedSubview(fila)
        }
    }

    private func etiquetaVacia(_ texto: String) -> UILabel {
        let label = UILabel()
        label.text = texto
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }
}
