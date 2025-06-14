//
//  SocialAppApp.swift
//  SocialApp
//
//  Created by hiwot alemu on 11/22/24.
//
import Firebase

import SwiftUI

@main
struct SocialAppApp: App {
    @StateObject var viewModel = AuthViewModel()
   
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
