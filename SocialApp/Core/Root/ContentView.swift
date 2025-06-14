//
//  ContentView.swift
//  SocialApp
//
//  Created by hiwot alemu on 11/22/24.
//

import SwiftUI
//
//@MainActor
struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
         Group {
             if let userSession = viewModel.userSession {
                 // User is logged in, show profile
                 ProfilePageView()
                     .environmentObject(viewModel) // Pass AuthViewModel to ProfilePageView
             } else {
                 // User is not logged in, show login screen
                 LoginView()
                     .environmentObject(viewModel) // Pass AuthViewModel to LoginView
             }
         }
     }
 }
//    var body: some View {
//        Group {
//            if let userSession = viewModel.userSession {
//                LoginView()
//            } else {
//                ProfileView()
//            }
//        }
//    }
//}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
//  .environmentObject(AuthViewModel()) // uncommented jan 6
//        print("Failed to create user")
    }
}
