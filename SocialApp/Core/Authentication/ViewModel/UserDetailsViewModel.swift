//
//  UserDetailsViewModel.swift
//  SocialApp
//
//  Created by hiwot alemu on 12/25/24.
//

import FirebaseFirestore
import FirebaseAuth

//class UserDetailsViewModel {
//    let db = Firestore.firestore()
//
//    func saveUserDetails(userID: String, username: String, phoneNumber: String, birthday: String, bio: String, completion: @escaping (Bool, Error?) -> Void) {
//        // Prepare the data
//        let userDetails: [String: Any] = [
//            "username": username,
//            "phoneNumber": phoneNumber,
//            "birthday": birthday,
//            "bio": bio,
//            "createdAt": Timestamp(date: Date()) // Store the time of account creation
//        ]
//        
//        // Save the user details to Firestore under the 'users' collection
//        db.collection("users").document(userID).setData(userDetails) { error in
//            if let error = error {
//                completion(false, error)
//            } else {
//                completion(true, nil)
//            }
//        }
//    }
//}
//
