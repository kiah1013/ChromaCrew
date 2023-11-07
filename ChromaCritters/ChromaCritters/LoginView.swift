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
    @State private var showingEmailSignIn = false // State to control email sign-in view presentation
    
    let signInWithAppleManager = SignInWithAppleManager()
    
    var body: some View {
        VStack(spacing: 20) {
            SignInWithAppleButton(.signIn, onRequest: { request in
                signInWithAppleManager.setupRequest(request)
            }, onCompletion: handleSignInWithApple)
            .frame(width: 280, height: 45)
            .cornerRadius(10)
            
            Button("Sign in with Email") {
                showingEmailSignIn = true
            }
            .frame(width: 280, height: 45)
            .cornerRadius(10)
            .sheet(isPresented: $showingEmailSignIn) {
                EmailSignInView() // This would be your custom view for email sign-in
            }
            
            Button("Sign Up") {
                showingRegistration = true
            }
            .frame(width: 280, height: 45)
            .cornerRadius(10)
            .sheet(isPresented: $showingRegistration) {
                RegistrationView()
            }
            
            Button("Continue as Guest") {
                userAuth.isGuest = true
            }
            .frame(width: 280, height: 45)
            .cornerRadius(10)
        }
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
