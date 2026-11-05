//
//  NuevoAlumnoView.swift
//  Apple_lab11_02_UIKIT_SwiftData
//
//  Created by Rony Jhostin on 5/11/26.
//

import SwiftUI
import SwiftData

struct NuevoAlumnoView: View {

    @Environment(\.modelContext) private var modelContext // Contexto del modelo (insertar, guardar, eliminar)
    @Environment(\.dismiss) private var dismiss             // Cierra esta vista (como un "volver")

    @State private var apellido = ""
    @State private var nombre = ""
    @State private var dni = ""
    @Query(sort: \Curso.nombre) private var cursos: [Curso]
    @State private var cursoSeleccionado: Curso?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 56))
                            .foregroundStyle(.indigo)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section(header: Text("Datos del Alumno")) {
                    LabeledTextField(systemImage: "person.text.rectangle", placeholder: "Apellido", text: $apellido)
                    LabeledTextField(systemImage: "person", placeholder: "Nombre", text: $nombre)
                    LabeledTextField(systemImage: "number", placeholder: "DNI", text: $dni)
                        .keyboardType(.numberPad)
                }

                if !cursos.isEmpty {
                    Section(header: Text("Curso")) {
                        Picker("Curso", selection: $cursoSeleccionado) {
                            Text("Sin curso").tag(Curso?.none)
                            ForEach(cursos) { curso in
                                Text(curso.nombre).tag(Optional(curso))
                            }
                        }
                    }
                }

                Section {
                    Button {
                        guardarAlumno()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Guardar Alumno", systemImage: "checkmark.circle.fill")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(apellido.isEmpty || nombre.isEmpty || dni.isEmpty) // Desactiva si hay campos vacíos
                }
            }
            .navigationTitle("Nuevo Alumno")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss() // Cierra el formulario sin guardar
                    }
                }
            }
        }
    }

    private func guardarAlumno() {
        // CREATE: crear el objeto e insertarlo en el contexto
        let nuevoAlumno = Alumno(apellido: apellido, nombre: nombre, dni: dni)
        nuevoAlumno.curso = cursoSeleccionado
        modelContext.insert(nuevoAlumno)

        // Guardamos de inmediato para asegurar la persistencia
        do {
            try modelContext.save()
        } catch {
            print("Error al guardar alumno: \(error)")
        }
        dismiss() // Cierra el formulario
    }
}
