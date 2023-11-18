//
//  Login.swift
//  ChromaCritters
//
//  Created by Kiah Epperson on 11/2/23.
//
import SwiftUI
import Foundation
import AuthenticationServices
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var userAuth: UserAuth
    @StateObject private var authView = AuthView()
    @State private var showingRegistration = false
    @State private var showingEmailSignIn = false 
    @Environment(\.colorScheme) var colorScheme

    
    let signInWithAppleManager = SignInWithAppleManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Image("logo copy")
                .resizable()
                .frame(width:100, height:100)
                .padding(.top, -100)
                
            SignInWithAppleButton(.signIn, onRequest: { request in
                signInWithAppleManager.setupRequest(request)
            }, onCompletion: handleSignInWithApple)
            .frame(width: 280, height: 45)
            .cornerRadius(10)
            
            Button("Sign in with Email") {
                showingEmailSignIn = true
            }
            .frame(width: 280, height: 45)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $showingEmailSignIn) {
                EmailSignInView() 
            }
            
            Button("Sign Up") {
                showingRegistration = true
            }
            .frame(width: 280, height: 45)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $showingRegistration) {
                RegistrationView()
            }
            
            Button("Continue as Guest") {
                userAuth.isGuest = true
            }
            .frame(width: 280, height: 45)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .light
                    ?    LinearGradient(gradient: Gradient(colors:
                                                            [Color(red: 254/255, green: 247/255, blue: 158/255),
                                                             Color(red:169/255, green: 255/255, blue: 158/255),
                                                             Color(red: 158/255, green: 249/255, blue: 252/255),
                                                             Color(red: 159/255, green: 158/255, blue: 254/255),
                                                             Color(red: 255/255, green: 155/255, blue: 233/255),
                                                             Color(red: 254/255, green: 195/255, blue: 155/255)]),
                                        startPoint: .topLeading, endPoint: .bottomTrailing)
                    
                    : LinearGradient(gradient: Gradient(colors:
                                                            [Color(red: 0, green: 0, blue: 0.2),
                                                             Color(red: 0.7, green: 0.25, blue: 0.9),
                                                             Color(red: 0.5, green: 0.35, blue: 0.9),
                                                             Color(red: 0.07, green: 0.2, blue: 0.3),
                                                             Color(red: 0, green: 0, blue: 0.2)]),
                                     startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
    private func handleSignInWithApple(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                userAuth.userId = appleIDCredential.user
                userAuth.isLogged = true
            }
        case .failure(let error):
            print("Apple Sign In failed: \(error.localizedDescription)")
        }
    }
}
class SignInWithAppleManager {
    func setupRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        request.nonce = nonce
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                arc4random_buf(&random, 1)
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < UInt8(charset.count) {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}
#Preview {
    LoginView()
}
