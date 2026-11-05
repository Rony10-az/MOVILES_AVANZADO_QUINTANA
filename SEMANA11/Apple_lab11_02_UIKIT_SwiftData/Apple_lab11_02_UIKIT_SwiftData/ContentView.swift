//
//  ContentView.swift
//  Apple_lab11_02_UIKIT_SwiftData
//
//  Created by Rony Jhostin on 5/11/26.
//

import SwiftUI
import SwiftData // Para consultar y manipular datos persistentes

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext // Contexto: insertar, borrar, guardar

    // READ: consulta automática de todos los alumnos ordenados por apellido
    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]

    @State private var alumnoSeleccionado: Alumno?    // Alumno seleccionado en la lista
    @State private var mostrarFormulario = false       // Muestra el formulario de nuevo alumno
    @State private var alumnoAEditar: Alumno?           // Alumno que se está editando
    @State private var busqueda = ""                    // Texto de búsqueda

    // Alumnos que coinciden con la búsqueda por apellido
    private var alumnosFiltrados: [Alumno] {
        if busqueda.isEmpty { return alumnos }
        return alumnos.filter { $0.apellido.localizedCaseInsensitiveContains(busqueda) }
    }

    var body: some View {
        NavigationSplitView { // Lista a la izquierda, detalle a la derecha
            Group {
                if alumnos.isEmpty {
                    ContentUnavailableView {
                        Label("Sin alumnos", systemImage: "person.3")
                    } description: {
                        Text("Pulsa + para registrar tu primer alumno")
                    }
                } else if alumnosFiltrados.isEmpty {
                    ContentUnavailableView.search(text: busqueda)
                } else {
                    List(selection: $alumnoSeleccionado) {
                        ForEach(alumnosFiltrados) { alumno in
                            NavigationLink(value: alumno) {
                                FilaAlumno(alumno: alumno)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    eliminar(alumno)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    alumnoAEditar = alumno
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                .tint(.indigo)
                            }
                        }
                        .onDelete(perform: deleteAlumnos) // Eliminar con swipe o modo edición
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Alumnos")
            .searchable(text: $busqueda, prompt: "Buscar por apellido")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        asignarCursoDemo()
                    } label: {
                        Label("Curso demo", systemImage: "book")
                    }
                }
                ToolbarItem {
                    Button {
                        mostrarFormulario = true
                    } label: {
                        Label("Nuevo Alumno", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if let alumno = alumnoSeleccionado {
                DetalleAlumno(alumno: alumno, onEditar: { alumnoAEditar = alumno })
            } else {
                ContentUnavailableView {
                    Label("Selecciona un alumno", systemImage: "person.crop.circle")
                } description: {
                    Text("Elige un alumno de la lista para ver sus detalles")
                }
            }
        }
        // Formulario de nuevo alumno como hoja flotante
        .sheet(isPresented: $mostrarFormulario) {
            NuevoAlumnoView()
        }
        // Formulario de edición
        .sheet(item: $alumnoAEditar) { alumno in
            EditarAlumnoView(alumno: alumno)
        }
    }

    // DELETE: eliminar uno o más alumnos desde la lista
    private func deleteAlumnos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                eliminar(alumnosFiltrados[index])
            }
        }
    }

    private func eliminar(_ alumno: Alumno) {
        withAnimation {
            if alumnoSeleccionado == alumno { alumnoSeleccionado = nil }
            modelContext.delete(alumno)
        }
    }

    // DEMOSTRACIÓN de relación: crea un curso y se lo asigna a todos los alumnos
    private func asignarCursoDemo() {
        let curso = Curso(nombre: "Programación en Móviles")
        modelContext.insert(curso)
        for alumno in alumnos {
            alumno.curso = curso
        }
    }
}

// MARK: - Fila de la lista

private struct FilaAlumno: View {
    let alumno: Alumno

    var body: some View {
        HStack(spacing: 14) {
            AvatarAlumno(alumno: alumno)

            VStack(alignment: .leading, spacing: 3) {
                Text("\(alumno.apellido), \(alumno.nombre)")
                    .font(.headline)
                HStack(spacing: 6) {
                    Image(systemName: "number")
                        .font(.caption2)
                    Text(alumno.dni)
                        .font(.subheadline.monospacedDigit())
                }
                .foregroundStyle(.secondary)

                if let curso = alumno.curso {
                    Label(curso.nombre, systemImage: "book.closed.fill")
                        .font(.caption)
                        .foregroundStyle(.indigo)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

private struct AvatarAlumno: View {
    let alumno: Alumno

    private var iniciales: String {
        let n = alumno.nombre.first.map(String.init) ?? ""
        let a = alumno.apellido.first.map(String.init) ?? ""
        let texto = (n + a).uppercased()
        return texto.isEmpty ? "?" : texto
    }

    var body: some View {
        Circle()
            .fill(LinearGradient(colors: [.indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 44, height: 44)
            .overlay(
                Text(iniciales)
                    .font(.headline)
                    .foregroundStyle(.white)
            )
    }
}

// MARK: - Detalle del alumno

private struct DetalleAlumno: View {
    let alumno: Alumno
    let onEditar: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    AvatarAlumno(alumno: alumno)
                        .scaleEffect(1.8)
                        .padding(.top, 12)
                    Text("\(alumno.nombre) \(alumno.apellido)")
                        .font(.title2.bold())
                    if let curso = alumno.curso {
                        Label(curso.nombre, systemImage: "book.closed.fill")
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.indigo.opacity(0.15), in: Capsule())
                            .foregroundStyle(.indigo)
                    }
                }

                VStack(spacing: 0) {
                    FilaDato(icono: "person", titulo: "Nombre", valor: alumno.nombre)
                    Divider().padding(.leading, 44)
                    FilaDato(icono: "person.text.rectangle", titulo: "Apellido", valor: alumno.apellido)
                    Divider().padding(.leading, 44)
                    FilaDato(icono: "number", titulo: "DNI", valor: alumno.dni)
                }
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                Button {
                    onEditar()
                } label: {
                    Label("Editar Alumno", systemImage: "pencil")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Detalle del Alumno")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct FilaDato: View {
    let icono: String
    let titulo: String
    let valor: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icono)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.indigo)
                .frame(width: 22)
            Text(titulo)
                .foregroundStyle(.secondary)
            Spacer()
            Text(valor)
                .fontWeight(.medium)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
