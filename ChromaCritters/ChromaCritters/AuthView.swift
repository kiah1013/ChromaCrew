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
    
    // Firebase Authentication and Firestore references
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    // Inside AuthView.swift
    func registerUser(withEmail email: String, password: String, fullname: String, username: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let uid = result?.user.uid {
                // Pass back the UID on success
                completion(.success(uid))
            } else {
                // Pass back a custom error if for some reason there is no error and no user
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
            }
        }
    }
}
