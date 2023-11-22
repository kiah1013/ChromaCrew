//
//  ChromaCrittersApp.swift
//  ChromaCritters
//
//  Created by Daniel Youssef on 10/12/23.
//

import SwiftUI
import AuthenticationServices
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class UserAuth: ObservableObject {
    @Published var isLogged: Bool = false
    @Published var userId: String? = nil
    @Published var isGuest: Bool = false
    @Published var username: String = ""

    func fetchUser() {
        if isLogged {
            let userUID = Auth.auth().currentUser?.uid
            Firestore.firestore().collection("users").document(userUID!).getDocument { snapshot, error in
                if error != nil {
                    // ERROR
                    print("Error getting username")
                }
                if let snapshot = snapshot, snapshot.exists {
                    let data = snapshot.data()
                    if let data = data {
                        //self.username = snapshot!.get("username") as! String
                        //print(data)
                        self.username = data["username"] as? String ?? ""
                    }
                }
                
            }
        } else {
            print("User not logged in, cannot fetch user's name")
        }
    }
}

@main

struct ChromaCrittersApp: App {
    @StateObject var userAuth = UserAuth()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isDarkMode") private var isDarkMode = false


    var body: some Scene {
        WindowGroup {
            if userAuth.isLogged {
                HomepageView().environmentObject(userAuth).preferredColorScheme(isDarkMode ? .dark : .light)
            } else if userAuth.isGuest {
                HomepageView().environmentObject(userAuth).preferredColorScheme(isDarkMode ? .dark : .light)
            } else {
                LoginView().environmentObject(userAuth).preferredColorScheme(isDarkMode ? .dark : .light)
            }
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
