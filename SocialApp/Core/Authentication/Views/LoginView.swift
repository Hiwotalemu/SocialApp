//
//  LoginView.swift
//  SocialApp
//
//  Created by hiwot alemu on 11/29/24.
//x

import SwiftUI



struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Image
                Image("logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                // Form
                VStack(spacing: 16) {
                    InputView(text: $email, title: "Email Address", placeholder: "user@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecuredField: true)
                }
                .padding(.horizontal)
                
                // Sign in button
                Button(action: {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                }) {
                    HStack {
                        Text("Log In")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.blue)
                            .disabled(!valid)
                            .opacity(valid ? 1.0: 0.5)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                }
                
                // Forgot password
                NavigationLink(destination: Text("Forgot Password View")) {
                    Text("Forgot Password?")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 16)
                }
                
                // Divider
                HStack {
                    VStack { Divider() }
                    Text("or")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    VStack { Divider() }
                }
             
        
                .padding(.horizontal)
                
                // Social sign-in options
//                HStack(spacing: 20) {
                
//                    SocialSignInButton(image: "apple.logo")
//                    SocialSignInButton(image: "google.logo")
//                    SocialSignInButton(image: "facebook.logo")
//                }
//                .padding(.top, 16)

                Spacer()
                
                // Sign up button
                NavigationLink(destination: SignupView().navigationBarBackButtonHidden(true)) {
                    HStack {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .font(.system(size: 14))
                    .padding(.bottom, 16)
                }
            }
            .padding()
        }
    }
}

struct SocialSignInButton: View {
    let image: String
    
    var body: some View {
        Button(action: {
            // Add social sign-in action here
        }) {
            Image(systemName: image)
                .foregroundColor(.black)
                .frame(width: 50, height: 50)
                .shadow(radius: 5)
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var valid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 6
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
//            .environmentObject(AuthViewModel())
    }
}
