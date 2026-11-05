//
//  LabeledTextField.swift
//  Apple_lab11_02_UIKIT_SwiftData
//
//  Created by Rony Jhostin on 5/11/26.
//

import SwiftUI

// Campo de formulario reutilizable con icono, usado en los formularios de alumno.
struct LabeledTextField: View {
    let systemImage: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.indigo)
                .frame(width: 22)
            TextField(placeholder, text: $text)
        }
    }
}
