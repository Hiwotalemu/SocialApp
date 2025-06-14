//
//  CreatePostView.swift
//  SocialApp
//
//  Created by hiwot alemu on 2/4/25.
//
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreCombineSwift


//
//func createPost(content: String, image: UIImage?) async {
//    guard let userId = Auth.auth().currentUser?.uid else { return }
//
//    var postData: [String: Any] = [
//        "userId": userId,
//        "content": content,
//        "timestamp": FieldValue.serverTimestamp()
//    ]
//
//    // Upload image if available
//    if let image = image, let imageData = image.jpegData(compressionQuality: 0.7) {
//        let postId = UUID().uuidString
//        let storageRef = Storage.storage().reference().child("posts/\(postId).jpg")
//
//        do {
//            let _ = try await storageRef.putDataAsync(imageData)
//            let imageUrl = try await storageRef.downloadURL()
//            postData["mediaUrl"] = imageUrl.absoluteString
//        } catch {
//            print("Error uploading post image: \(error.localizedDescription)")
//        }
//    }
//
//    // Save to Firestore
//    do {
//        let _ = try await Firestore.firestore().collection("posts").addDocument(data: postData)
//        print("Post uploaded successfully!")
//    } catch {
//        print("Error uploading post: \(error.localizedDescription)")
//    }
//}
