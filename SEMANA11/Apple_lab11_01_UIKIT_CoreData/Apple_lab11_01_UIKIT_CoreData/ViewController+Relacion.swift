//
//  ViewController+Relacion.swift
//  Apple_lab11_01_UIKIT_CoreData
//
//  Created by Rony Jhostin on 5/11/26.
//

import UIKit
import CoreData

extension ViewController{
    // fecth request con predicate simple: buscar por texto en el nombbre
    
    func buscarContactos(texto: String) -> [Contacto] {
        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        request.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@", texto)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        return (try? conexion().fetch(request)) ?? []
    }

    // Crea un grupo y se lo asigna al primer contacto. Ejecutala UNA sola vez
    // por ejemplo desde viewDidLoad y luego vuelve a comentarla
    func probarRelacion() {
        let contexto = conexion()
        let grupo = NSEntityDescription.insertNewObject(forEntityName: "Grupo", into: contexto) as! Grupo
        grupo.nombre = "Amigos"
        if let primero = contactos.first {
            primero.grupo = grupo
        }
        do{
            try contexto.save()
            print("El grupo \(grupo.nombre ?? "") tiene \(grupo.contactos?.count ?? 0) contacto(s)")
        } catch {
            print("Error al guardar la relacion: \(error)")
        }
    }

    // fetch request con predicate que recorre la relacion
    func contactosDelGrupo(_ nombreGrupo : String) -> [Contacto] {
        let request : NSFetchRequest<Contacto> = Contacto.fetchRequest()
        request.predicate = NSPredicate(format: "grupo.nombre == %@", nombreGrupo)
        return (try? conexion().fetch(request)) ?? []
    }
}
