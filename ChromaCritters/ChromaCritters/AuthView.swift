//
//  AuthView.swift
//  ChromaCritters
//
//  Created by Kiah Epperson on 11/2/23.
//
import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AuthView: ObservableObject {
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    func registerUser(withEmail email: String, password: String, fullname: String, username: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let uid = result?.user.uid {
                completion(.success(uid))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
            }
        }
    }
}
