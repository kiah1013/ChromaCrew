//
//  ContentView.swift
//  ChromaCritters
//
//  Created by Daniel Youssef on 9/27/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        VStack {
            if userAuth.isLogged || userAuth.isGuest {
                HomepageView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserAuth()) 
    }
}
