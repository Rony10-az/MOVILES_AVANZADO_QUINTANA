//
//  MessagesView.swift
//  Lab14IntroFirebase
//
//  Created by Rony Jhostin on 24/11/26.
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {
    @State private var messages: [Message] = []
    @State private var newMessage = ""

    private var currentUserEmail: String {
        Auth.auth().currentUser?.email ?? ""
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            MessageBubble(message: message, isMine: message.senderEmail == currentUserEmail)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: messages.count) {
                    if let lastId = messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }

            HStack {
                TextField("Escribe un mensaje", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Enviar") {
                    DatabaseService.shared.sendMessage(newMessage)
                    newMessage = ""
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
        .navigationTitle("Mensajes")
        .onAppear {
            DatabaseService.shared.observeMessages { updatedMessages in
                messages = updatedMessages
            }
        }
        .onDisappear {
            DatabaseService.shared.removeAllObservers()
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let isMine: Bool

    var body: some View {
        HStack {
            if isMine { Spacer() }
            VStack(alignment: .leading, spacing: 2) {
                Text(message.senderEmail)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(message.text)
                    .padding(8)
                    .background(isMine ? Color.blue : Color(.systemGray5))
                    .foregroundColor(isMine ? .white : .primary)
                    .cornerRadius(10)
            }
            if !isMine { Spacer() }
        }
    }
}

#Preview {
    NavigationView {
        MessagesView()
    }
}
