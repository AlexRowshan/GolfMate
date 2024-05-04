//
//  FinalProject342App.swift
//  FinalProject342
//
//  Created by Alex Rowshan on 4/29/24.
//

import SwiftUI
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct FinalProject342App: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
                //Handle Google Oauth URL
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
