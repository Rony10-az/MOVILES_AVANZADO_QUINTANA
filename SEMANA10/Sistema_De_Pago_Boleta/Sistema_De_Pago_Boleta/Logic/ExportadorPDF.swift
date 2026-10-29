import SwiftUI

/// Convierte una vista SwiftUI en un PDF de una página (tamaño carta) y lo guarda
/// en un archivo temporal. Patrón estándar de ImageRenderer + CGContext para PDF.
@MainActor
enum ExportadorPDF {

    static func generar(_ vista: some View) -> URL? {
        let renderer = ImageRenderer(content: vista)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("boleta-\(UUID().uuidString).pdf")

        guard let consumidor = CGDataConsumer(url: url as CFURL) else { return nil }
        var pagina = CGRect(x: 0, y: 0, width: 612, height: 792) // carta, en puntos
        guard let contexto = CGContext(consumer: consumidor, mediaBox: &pagina, nil) else { return nil }

        renderer.render { _, renderizarEnContexto in
            contexto.beginPDFPage(nil)
            renderizarEnContexto(contexto)
            contexto.endPDFPage()
            contexto.closePDF()
        }

        return url
    }
}
