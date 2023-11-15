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
                Image("logo copy")
                    .resizable()
                    .frame(width:100, height:100)
                    .padding(.top, 50)
                    
                
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
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(5)
                
                Spacer()
            }
            
            .padding()
            .navigationBarTitle("Sign In", displayMode: .inline)
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 254/255, green: 247/255, blue: 158/255),
                                                                   Color(red:169/255, green: 255/255, blue: 158/255),
                                                                   Color(red: 158/255, green: 249/255, blue: 252/255),
                                                                   Color(red: 159/255, green: 158/255, blue: 254/255),
                                                                   Color(red: 255/255, green: 155/255, blue: 233/255),
                                                                   Color(red: 254/255, green: 195/255, blue: 155/255)]), startPoint: .topLeading, endPoint: .bottomTrailing))
          
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
