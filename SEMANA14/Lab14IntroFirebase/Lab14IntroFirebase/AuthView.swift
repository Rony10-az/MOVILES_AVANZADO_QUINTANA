//
//  AuthView.swift
//  Lab14IntroFirebase
//
//  Created by Rony Jhostin on 24/11/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var authStateListener: AuthStateDidChangeListenerHandle?
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Lab 14: Firebase")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                Spacer()
                if isSignedIn {
                    // Signed in view
                    VStack(spacing: 20) {
                        Text("Welcome!")
                            .font(.title)
                            .foregroundColor(.green)
                        Text("You are signed in")
                            .font(.body)
                        NavigationLink("Ir a mensajes") {
                            MessagesView()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        Button("Sign Out") {
                            signOut()
                        }
                        .buttonStyle(SignOutButtonStyle())
                    }
                } else {
                    // Sign in form
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        HStack(spacing: 20) {
                            Button("Sign In") {
                                signIn()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            Button("Sign Up") {
                                signUp()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                    .padding(.horizontal, 30)
                }
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .alert("Message", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthState()
        }
        .onDisappear {
            if let listener = authStateListener {
                Auth.auth().removeStateDidChangeListener(listener)
            }
        }
        .onChange(of: isSignedIn) {
            // Clear form when signing out
            if !isSignedIn {
                email = ""
                password = ""
            }
        }
    }

    // MARK: - Authentication Functions

    private func checkAuthState() {
        authStateListener = Auth.auth().addStateDidChangeListener { _, user in
            isSignedIn = (user != nil)
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }

    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                alertMessage = "Usuario registrado correctamente"
                showAlert = true
            }
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}


// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
struct SignOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
#Preview {
    AuthView()
}
