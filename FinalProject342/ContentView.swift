//
//  ContentView.swift
//  FinalProject342
//
//  Created by Alex Rowshan on 4/29/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)

    var body: some View {
        VStack {
            if userLoggedIn {
                CourseMap()
            } else {
                Login()
            }
        }.onAppear{
            //Firebase state change listeneer
            Auth.auth().addStateDidChangeListener{ auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
