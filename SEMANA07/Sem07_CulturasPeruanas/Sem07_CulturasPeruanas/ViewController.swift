//
//  ViewController.swift
//  Sem07_CulturasPeruanas
//
//  Created by Rony Jhostin on 13/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCulturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //crear un objeto para que se muestre la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda") as! CulturaTableViewCell
        cell.nombreCultura.text = listaCulturas[indexPath.row].nombre
        cell.fotoCultura.image = listaCulturas[indexPath.row].imagen
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        culturaSeleccionada = listaCulturas[indexPath.row]
        performSegue(withIdentifier: "irADetalle", sender: self)
    }

    // Lista de Culturas Peruanas

    var listaCulturas = [
        Cultura(nombre: "Cultura Chavín", region: "Áncash", descripcion: "Una de las civilizaciones más antiguas del Perú, desarrollada entre los años 1200 a.C. y 200 a.C. Se le considera la cultura matriz de los Andes, ya que su influencia religiosa y artística se extendió a lo largo de la costa y sierra peruana. Destacó por su arquitectura monumental, su culto al dios felino y su refinado trabajo en piedra y cerámica.", imagen: UIImage(named: "chavin"), lugares: [
            Lugar(nombre: "Templo de Chavín de Huántar", ubicacion: "Distrito de Chavín de Huántar, provincia de Huari, Áncash", descripcion: "Complejo ceremonial principal de la cultura Chavín, famoso por sus galerías subterráneas y el Lanzón Monolítico. Declarado Patrimonio de la Humanidad por la UNESCO en 1985.", imagen: UIImage(named: "chavin_templo")),
            Lugar(nombre: "Obelisco Tello", ubicacion: "Museo Nacional de Chavín, Áncash", descripcion: "Monolito tallado con representaciones de deidades y simbología religiosa chavín, hallado originalmente en el templo principal.", imagen: UIImage(named: "chavin_obelisco"))
        ]),
        Cultura(nombre: "Cultura Nazca", region: "Ica", descripcion: "Se desarrolló entre los años 100 a.C. y 800 d.C. en la costa sur del Perú. Es mundialmente famosa por las Líneas de Nazca, enormes geoglifos trazados en el desierto cuyo propósito exacto (astronómico, religioso o hidráulico) aún es motivo de estudio. También sobresalió por su cerámica policromada y sus avanzados sistemas de irrigación subterránea.", imagen: UIImage(named: "nazca"), lugares: [
            Lugar(nombre: "Líneas de Nazca", ubicacion: "Pampas de Nazca y Palpa, provincia de Nazca, Ica", descripcion: "Geoglifos gigantes trazados en el desierto que representan animales y figuras geométricas, visibles desde el aire. Patrimonio de la Humanidad desde 1994.", imagen: UIImage(named: "nazca_lineas")),
            Lugar(nombre: "Acueductos de Cantalloc", ubicacion: "A 4 km de la ciudad de Nazca, Ica", descripcion: "Sistema de canales subterráneos construido para abastecer de agua a la zona desértica de Nazca, aún en uso parcial actualmente.", imagen: UIImage(named: "nazca_acueductos"))
        ]),
        Cultura(nombre: "Cultura Moche", region: "La Libertad", descripcion: "Floreció entre los años 100 y 800 d.C. en los valles costeros del norte del Perú. Fue una sociedad guerrera y teocrática, gobernada por sacerdotes-guerreros, que alcanzó un alto desarrollo en metalurgia, hidráulica y cerámica realista (los famosos 'huaco retrato'). Sus principales templos, las Huacas del Sol y de la Luna, reflejan su compleja organización religiosa.", imagen: UIImage(named: "moche"), lugares: [
            Lugar(nombre: "Huaca del Sol", ubicacion: "Valle de Moche, a 5 km al sur de Trujillo, La Libertad", descripcion: "La pirámide de adobe más grande del Perú, centro ceremonial y administrativo de la cultura Moche.", imagen: UIImage(named: "moche_huacasol")),
            Lugar(nombre: "Huaca de la Luna", ubicacion: "Valle de Moche, a 5 km al sur de Trujillo, La Libertad", descripcion: "Templo decorado con murales polícromos que representan a la deidad moche Ai Apaec, muy bien conservado.", imagen: UIImage(named: "moche_huacaluna"))
        ]),
        Cultura(nombre: "Cultura Chimú", region: "La Libertad", descripcion: "Se desarrolló entre los años 900 y 1470 d.C., siendo el reino más poderoso de la costa norte antes de la expansión inca, hasta que fue conquistado por el Inca Túpac Yupanqui. Destacaron como hábiles orfebres del oro y la plata, y construyeron Chan Chan, la ciudad de barro (adobe) más grande de la América precolombina.", imagen: UIImage(named: "chimu"), lugares: [
            Lugar(nombre: "Chan Chan", ubicacion: "A 5 km al oeste de Trujillo, La Libertad", descripcion: "La ciudad de barro (adobe) más grande de la América precolombina, capital del reino Chimú. Patrimonio de la Humanidad desde 1986.", imagen: UIImage(named: "chimu_chanchan")),
            Lugar(nombre: "Palacio Nik An", ubicacion: "Interior del complejo de Chan Chan, Trujillo, La Libertad", descripcion: "Uno de los recintos mejor conservados de Chan Chan, con muros decorados en relieve de figuras marinas y geométricas.", imagen: UIImage(named: "chimu_nikan"))
        ]),
        Cultura(nombre: "Cultura Inca", region: "Cusco", descripcion: "El Imperio Inca (Tahuantinsuyo) se expandió entre los siglos XIII y XVI, llegando a ser el imperio más grande de la América precolombina, con territorio desde el sur de Colombia hasta el centro de Chile. Tuvo como capital la ciudad del Cusco y desarrolló una avanzada red de caminos (el Qhapaq Ñan), sistemas agrícolas en terrazas y una sólida organización política y religiosa, hasta su caída tras la conquista española en 1533.", imagen: UIImage(named: "inca"), lugares: [
            Lugar(nombre: "Machu Picchu", ubicacion: "Provincia de Urubamba, departamento de Cusco", descripcion: "Ciudadela inca construida en la cima de una montaña, considerada una de las nuevas siete maravillas del mundo y Patrimonio de la Humanidad.", imagen: UIImage(named: "inca_machupicchu")),
            Lugar(nombre: "Sacsayhuamán", ubicacion: "A 2 km al norte de la ciudad del Cusco", descripcion: "Complejo arqueológico de grandes muros de piedra, ubicado en las alturas de la ciudad del Cusco. Antigua fortaleza ceremonial inca.", imagen: UIImage(named: "inca_sacsayhuaman")),
            Lugar(nombre: "Qorikancha", ubicacion: "Centro histórico de la ciudad del Cusco", descripcion: "El templo del Sol, el recinto religioso más importante del Imperio Inca, hoy integrado al Convento de Santo Domingo.", imagen: UIImage(named: "inca_qorikancha"))
        ])
    ]
    //Metodos del data source

    var culturaSeleccionada: Cultura!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irADetalle" {
            let detalleVC = segue.destination as! DetalleViewController
            detalleVC.cultura = culturaSeleccionada
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
