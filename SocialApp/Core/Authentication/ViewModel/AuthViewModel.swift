//
//  AuthViewModel.swift
//  SocialApp
//
//  Created by hiwot alemu on 11/30/24.
//
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreCombineSwift

protocol AuthenticationFormProtocol {
    var valid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var hasCreatedAccount: Bool = false

    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
                    self?.userSession = user
                    
                    if let user = user {
                        Task {
                            await self?.fetchUser()
                        }
                    }
                }
            }
//
//      private func fetchUserOnInit() {
//          Task {
//              await fetchUser()
//          }
//      }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in: \(error.localizedDescription)")
            self.errorMessage = "Failed to log in: \(error.localizedDescription)"
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
            self.errorMessage = "Failed to create user: \(error.localizedDescription)"
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to log out: \(error.localizedDescription)")
            self.errorMessage = "Failed to log out: \(error.localizedDescription)"
        }
    }
    
    func deleteAccount() {
        // Implement account deletion logic here
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
            self.errorMessage = "Failed to fetch user: \(error.localizedDescription)"
        }
    }
//    func isProfileComplete() -> Bool {
//            guard let currentUser = currentUser else { return false }
//            return !currentUser.username.isEmpty
//        }
}


