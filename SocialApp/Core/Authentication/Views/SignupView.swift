//
//  SignupView.swift
//  SocialApp
//
//  Created by hiwot alemu on 11/29/24.
//

import SwiftUI


struct SignupView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showUserDetailView = false
    @EnvironmentObject var userData: UserData
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image("logo2")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.vertical, 2)
            
            // Form
            VStack(spacing: 10) {
                InputView(text: $email, title: "Email Address", placeholder: "user@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $fullname, title: "Full Name", placeholder: "Enter your Name")
                    .autocapitalization(.none)
                
                InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecuredField: true)
                
                ZStack(alignment: .trailing){
                InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecuredField: true)
                
                
                    if !password.isEmpty && !confirmPassword.isEmpty{
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        }
                        else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                            .foregroundColor(Color(.systemRed))}
                    }
                }
                
            }
            .padding(.horizontal)
            .padding(.top, 44)
            
            Button {
                           Task {
                               do {
                                   // Create the user with email and password
                                   try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                                   
//                                   // Update userData with the email and fullname
//                                   userData.username = fullname  // Set the username to fullname for now
//                                   
                                   // Upon successful account creation, navigate to UserDetailView
                                   showUserDetailView = true
                               } catch {
                                   // Handle the error (e.g., show an alert)
                                   print("Error creating user: \(error.localizedDescription)")
                               }
                           }
            
//            Button {
//                Task {
//                    try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
//                    
//                }
            } label: {
                HStack {
//               

                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!valid)
                .opacity(valid ? 1.0: 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
            }
            
            Spacer()
            
            // Already Have an Account
            HStack {
                Text("Already have an account?")
                Button {
                    dismiss()
                } label: {
                    Text("Log In")
                        .fontWeight(.bold)
                }
            }
            .font(.system(size: 14))
            .padding(.bottom, 16)
        }
        .padding()
//        .background(
            
            NavigationLink("", destination: UserDetView(), isActive: $showUserDetailView)
                       .hidden()
                  
    }
}

extension SignupView: AuthenticationFormProtocol {
    var valid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 6
        && confirmPassword == password
        && !fullname.isEmpty
    
    }
}
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
//            .environmentObject(AuthViewModel())
    }
}
