//
//  RegistrationView.swift
//  ChromaCritters
//
//  Created by Kiah Epperson on 11/6/23.
//

import Foundation
import SwiftUI
import Foundation
import AuthenticationServices
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct User {
    let id: String
    let email: String
    let fullname: String
    let username: String
}

struct RegistrationView: View {
    @StateObject private var authView = AuthView()
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var username = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $fullname)
                    TextField("Username", text: $username)
                }
                
                Section(header: Text("Account Information")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                }
                
                Section {
                    Button("Register") {
                        // Here we pass the state variables instead of hardcoded strings
                        registerNewUser(email: email, password: password, fullname: fullname, username: username)
                    }
                }
            }
            .navigationBarTitle("Register", displayMode: .inline)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Registration Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Inside RegistrationView.swift
    private func registerNewUser(email: String, password: String, fullname: String, username: String) {
        authView.registerUser(withEmail: email, password: password, fullname: fullname, username: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let uid): // uid is the user ID from the successful registration
                    print("User registration successful")
                    userAuth.userId = uid // Set the user ID
                    userAuth.isLogged = true

                    let newUser = User(id: uid, email: email, fullname: fullname, username: username)
                    addUserToFirestore(user: newUser)

                    // Navigate away from the registration screen or update the UI as needed
                case .failure(let error):
                    print("Error registering user: \(error.localizedDescription)")
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
    
    private func addUserToFirestore(user: User) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.id)
       
        userRef.setData([
            "id": user.id,
            "email": user.email,
            "fullname": user.fullname,
            "username": user.username
        ]) { error in
            if let error = error {
                print("Error adding user to Firestore: \(error.localizedDescription)")
            } else {
                print("User added to Firestore successfully")
            }
        }
    }
}
