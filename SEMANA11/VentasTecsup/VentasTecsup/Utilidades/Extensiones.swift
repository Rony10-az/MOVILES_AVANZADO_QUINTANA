//
//  Extensiones.swift
//  VentasTecsup
//
//  Helpers compartidos por varias pantallas.
//

import UIKit

extension Double {
    /// Formatea un monto como "S/ 1,234.56".
    var comoMoneda: String {
        let formateador = NumberFormatter()
        formateador.numberStyle = .decimal
        formateador.minimumFractionDigits = 2
        formateador.maximumFractionDigits = 2
        formateador.groupingSeparator = ","
        formateador.decimalSeparator = "."
        let numero = formateador.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
        return "S/ \(numero)"
    }
}

extension UIViewController {

    /// Muestra una alerta simple con un botón "OK".
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
}

extension UIColor {
    static let tecsupAzul = UIColor.systemBlue
    static let tecsupVerde = UIColor.systemGreen
    static let tecsupAmbar = UIColor.systemOrange
    static let tecsupRojo = UIColor.systemRed
}

/// Insignia tipo "pill" (texto corto sobre fondo de color, esquinas redondeadas).
final class InsigniaLabel: UILabel {
    init(texto: String, color: UIColor) {
        super.init(frame: .zero)
        text = texto
        font = .boldSystemFont(ofSize: 11)
        textColor = .white
        textAlignment = .center
        backgroundColor = color
        layer.cornerRadius = 9
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no implementado") }

    override var intrinsicContentSize: CGSize {
        let base = super.intrinsicContentSize
        return CGSize(width: base.width + 16, height: max(18, base.height + 4))
    }
}

extension String {
    /// Hasta dos iniciales en mayúscula, a partir de las primeras palabras del texto.
    var iniciales: String {
        let palabras = split(separator: " ")
        let letras = palabras.prefix(2).compactMap { $0.first }
        return String(letras).uppercased()
    }
}

/// Paleta fija para avatares, elegida de forma estable según el texto (mismo nombre, mismo color).
func colorAvatar(para texto: String) -> UIColor {
    let paleta: [UIColor] = [.systemBlue, .systemPurple, .systemTeal, .systemIndigo, .systemPink, .systemOrange]
    let indice = abs(texto.hashValue) % paleta.count
    return paleta[indice]
}

/// Imagen circular con las iniciales de un nombre, lista para `UIListContentConfiguration.image`.
func imagenAvatar(nombre: String, diametro: CGFloat = 36) -> UIImage {
    let renderizador = UIGraphicsImageRenderer(size: CGSize(width: diametro, height: diametro))
    return renderizador.image { contexto in
        let rect = CGRect(x: 0, y: 0, width: diametro, height: diametro)
        colorAvatar(para: nombre).setFill()
        UIBezierPath(ovalIn: rect).fill()

        let texto = nombre.iniciales as NSString
        let estilo: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: diametro * 0.4),
            .foregroundColor: UIColor.white
        ]
        let tamano = texto.size(withAttributes: estilo)
        let origen = CGPoint(x: (diametro - tamano.width) / 2, y: (diametro - tamano.height) / 2)
        texto.draw(at: origen, withAttributes: estilo)
    }
}

/// Círculo con las iniciales de un nombre, para usarlo como accessoryView.
final class AvatarView: UIView {
    init(nombre: String, diametro: CGFloat = 38) {
        super.init(frame: CGRect(x: 0, y: 0, width: diametro, height: diametro))
        backgroundColor = colorAvatar(para: nombre)
        layer.cornerRadius = diametro / 2

        let label = UILabel()
        label.text = nombre.iniciales
        label.font = .boldSystemFont(ofSize: diametro * 0.38)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no implementado") }
}
