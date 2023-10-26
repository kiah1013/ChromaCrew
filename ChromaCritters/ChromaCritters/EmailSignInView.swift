//
//  EmailSignInView.swift
//  ChromaCritters
//
//  Created by Kiah Epperson on 11/6/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct EmailSignInView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorText: String? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                    .padding(.bottom, 10)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                    .padding(.bottom, 10)
                
                if let errorText = errorText {
                    Text(errorText)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button("Sign In") {
                    signInWithEmail(email: email, password: password)
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Sign In", displayMode: .inline)
        }
    }
    
    private func signInWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle errors like wrong password, user not found etc.
                self.errorText = error.localizedDescription
            } else if let authResult = authResult {
                // Update our app's user authentication state
                DispatchQueue.main.async {
                    self.userAuth.userId = authResult.user.uid
                    self.userAuth.isLogged = true
                }
            }
        }
    }
}

struct EmailSignInView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignInView().environmentObject(UserAuth())
    }
}
