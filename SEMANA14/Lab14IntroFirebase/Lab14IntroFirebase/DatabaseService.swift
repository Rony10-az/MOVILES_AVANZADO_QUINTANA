//
//  DatabaseService.swift
//  Lab14IntroFirebase
//
//  Created by Rony Jhostin on 24/11/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Message: Identifiable {
    let id: String
    let text: String
    let senderEmail: String
    let timestamp: Date
}

final class DatabaseService {
    static let shared = DatabaseService()

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    private init() {}

    func sendMessage(_ text: String) {
        guard let email = Auth.auth().currentUser?.email,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        db.collection("messages").addDocument(data: [
            "text": text,
            "senderEmail": email,
            "timestamp": FieldValue.serverTimestamp()
        ])
    }

    func observeMessages(onUpdate: @escaping ([Message]) -> Void) {
        listener = db.collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let messages = documents.compactMap { doc -> Message? in
                    let data = doc.data()
                    guard let text = data["text"] as? String,
                          let senderEmail = data["senderEmail"] as? String else { return nil }
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    return Message(id: doc.documentID, text: text, senderEmail: senderEmail, timestamp: timestamp)
                }
                onUpdate(messages)
            }
    }

    func removeAllObservers() {
        listener?.remove()
        listener = nil
    }
}
