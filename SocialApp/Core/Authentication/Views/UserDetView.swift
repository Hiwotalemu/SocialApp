//
//  UserDetView.swift
//  SocialApp
//
//  Created by hiwot alemu on 12/23/24.
import SwiftUI

struct UserDetView: View {
    @StateObject private var userData = UserData()
    @State private var username = ""
    @State private var hasAttemptedSubmit = false  // New state variable to track if the user has tried to submit
    
    // A computed property to validate the username
    private var usernameValidationMessage: String {
        if username.isEmpty {
            return "Username is required"
        } else if username.count < 3 {
            return "Username must be at least 3 characters"
        } else if username.contains(" ") {
            return "Username cannot contain spaces"
        }
        return ""
    }
    
    // Check if the username is valid
    private var isUsernameValid: Bool {
        return username.count >= 3 && !username.contains(" ")
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Spacer().frame(height: 60)
                
                Text("Create Username")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("This username can be changed later")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                ZStack(alignment: .trailing) {  // ZStack for checkmark/xmark alignment
                    TextField("Username", text: $username)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.top, 20)
                        .onChange(of: username) { newValue in
                            userData.username = newValue // Update userData.username when username changes
                        }
                    
                    // Checkmark or X icon
                    if hasAttemptedSubmit {
                        Image(systemName: isUsernameValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isUsernameValid ? .green : .red)
                            .imageScale(.large)
                            .padding(.trailing, 10)
                    }
                }
                
                // Validation message (shown after submit attempt)
                if hasAttemptedSubmit && !usernameValidationMessage.isEmpty {
                    Text(usernameValidationMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
            
            // Next button with navigation
            HStack {
                Spacer()
                Button(action: {
                    hasAttemptedSubmit = true  // Mark the user as having attempted submission
                }) {
                    NavigationLink(destination: UserDetailsView()
                        .environmentObject(userData)) {
                        Text("Next")
                            .fontWeight(.semibold)
                            .foregroundColor(isUsernameValid ? .blue : .gray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                }
                .disabled(!isUsernameValid)
                .animation(.easeInOut, value: isUsernameValid)
            }
            .padding(.bottom, 30)
            .padding(.trailing, 24)
        }
        .padding(.horizontal, 24)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct UserDetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDetView()
        }
    }
}
 
//import SwiftUI
//
//struct UserDetView: View {
//    @StateObject private var userData = UserData()
//    @State private var username = ""
//    @State private var hasAttemptedSubmit = false  // New state variable to track if the user has tried to submit
//    
//    // A computed property to validate the username
//    private var usernameValidationMessage: String {
//        if username.isEmpty {
//            return "Username is required"
//        } else if username.count < 8 {
//            return "Username must be at least 8 characters"
//        } else if username.contains(" ") {
//            return "Username cannot contain spaces"
//        }
//        return ""
//    }
//    
//    // Check if the username is valid
//    private var isUsernameValid: Bool {
//        return username.count >= 3 && !username.contains(" ")
//    }
//    
//    var body: some View {
//        VStack(spacing: 24) {
//            VStack(spacing: 8) {
//                Spacer().frame(height: 60)
//                
//                Text("Create Username")
//                    .font(.system(size: 34, weight: .bold, design: .rounded))
//                    .foregroundColor(.primary)
//                
//                Text("This username can be changed later")
//                    .foregroundColor(.gray)
//                    .font(.subheadline)
//                
//                ZStack(alignment: .trailing) {  // ZStack for checkmark/xmark alignment
//                    TextField("Username", text: $username)
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color.gray.opacity(0.1))
//                        )
//                        .textInputAutocapitalization(.never)
//                        .autocorrectionDisabled()
//                        .padding(.top, 20)
//                        .onChange(of: username) { newValue in
//                            userData.username = newValue // Update userData.username when username changes
//                        }
//                    
//                    // Checkmark or X icon
//                    if hasAttemptedSubmit {
//                        Image(systemName: isUsernameValid ? "checkmark.circle.fill" : "xmark.circle.fill")
//                            .foregroundColor(isUsernameValid ? .green : .red)
//                            .imageScale(.large)
//                            .padding(.trailing, 10)
//                    }
//                }
//                
//                // Validation message (shown after submit attempt)
//                if hasAttemptedSubmit && !usernameValidationMessage.isEmpty {
//                    Text(usernameValidationMessage)
//                        .foregroundColor(.red)
//                        .font(.caption)
//                        .padding(.horizontal)
//                }
//            }
//            
//            Spacer()
//            
//            // Next button with navigation
//            HStack {
//                Spacer()
//                Button(action: {
//                    hasAttemptedSubmit = true  // Mark the user as having attempted submission
//                }) {
//                    NavigationLink(destination: UserDetailsView()
//                        .environmentObject(userData)) {
//                        Text("Next")
//                            .fontWeight(.semibold)
//                            .foregroundColor(isUsernameValid ? .blue : .gray)
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 10)
//                    }
//                }
//                .disabled(!isUsernameValid)
//                .animation(.easeInOut, value: isUsernameValid)
//            }
//            .padding(.bottom, 30)
//            .padding(.trailing, 24)
//        }
//        .padding(.horizontal, 24)
//        .navigationBarTitleDisplayMode(.large)
//    }
//}
//

