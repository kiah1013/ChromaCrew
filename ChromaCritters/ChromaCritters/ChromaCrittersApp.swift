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
}

@main
struct ChromaCrittersApp: App {
    @StateObject var userAuth = UserAuth()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if userAuth.isLogged {
                HomepageView().environmentObject(userAuth)
            } else if userAuth.isGuest {
                HomepageView().environmentObject(userAuth)
            } else {
                LoginView().environmentObject(userAuth)
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
