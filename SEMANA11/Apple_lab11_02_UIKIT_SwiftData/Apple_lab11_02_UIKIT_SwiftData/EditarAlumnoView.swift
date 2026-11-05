//
//  EditarAlumnoView.swift
//  Apple_lab11_02_UIKIT_SwiftData
//
//  Created by Rony Jhostin on 5/11/26.
//

import SwiftUI
import SwiftData

// UPDATE: editar un alumno existente.
// @Bindable permite enlazar los campos directamente a las propiedades del objeto @Model.
// SwiftData detecta el cambio y lo guarda solo.
struct EditarAlumnoView: View {

    @Bindable var alumno: Alumno
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Curso.nombre) private var cursos: [Curso]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(LinearGradient(colors: [.indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 72, height: 72)
                            .overlay(
                                Text(iniciales)
                                    .font(.title2.bold())
                                    .foregroundStyle(.white)
                            )
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section(header: Text("Datos del Alumno")) {
                    LabeledTextField(systemImage: "person.text.rectangle", placeholder: "Apellido", text: $alumno.apellido)
                    LabeledTextField(systemImage: "person", placeholder: "Nombre", text: $alumno.nombre)
                    LabeledTextField(systemImage: "number", placeholder: "DNI", text: $alumno.dni)
                        .keyboardType(.numberPad)
                }

                if !cursos.isEmpty {
                    Section(header: Text("Curso")) {
                        Picker("Curso", selection: $alumno.curso) {
                            Text("Sin curso").tag(Curso?.none)
                            ForEach(cursos) { curso in
                                Text(curso.nombre).tag(Optional(curso))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Editar Alumno")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private var iniciales: String {
        let a = alumno.apellido.first.map(String.init) ?? ""
        let n = alumno.nombre.first.map(String.init) ?? ""
        let texto = (n + a).uppercased()
        return texto.isEmpty ? "?" : texto
    }
}

#Preview {
    EditarAlumnoView(alumno: Alumno(apellido: "Pérez", nombre: "Ana", dni: "12345678"))
        .modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
