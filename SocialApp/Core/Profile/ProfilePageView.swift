//
//  ProfilePageView.swift
//  SocialApp
//
//  Created by hiwot alemu on 1/6/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

struct ProfilePageView: View {
    @StateObject var viewModel = AuthViewModel()
    @State private var followersCount: Int = 0
    @State private var followingCount: Int = 0
    @State private var posts: [Post] = []
    @State private var selectedTab: String = "Posts"
    @State private var profileImage: UIImage?
    @State private var selectedImage: PhotosPickerItem?
    @State private var profileImageUrl: String?

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .background(Circle().fill(Color.black).frame(width: 90, height: 90))
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .background(Circle().fill(Color.black).frame(width: 90, height: 90))
                    }

                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        Text("Change Profile Picture")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .onChange(of: selectedImage) { newItem in
                        Task {
                            if let newItem = newItem, let data = try? await newItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                profileImage = uiImage
                                await uploadProfileImage(uiImage)
                            }
                        }
                    }

                    Text(viewModel.currentUser?.fullname ?? "Username")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                }
                .padding(.top, 8)

                HStack {
                    Spacer()
                    NavigationLink(destination: FollowersView()) {
                        VStack {
                            Text("Followers")
                                .font(.headline)
                            Text("\(followersCount)")
                                .font(.subheadline)
                        }
                        .foregroundColor(.primary)
                    }
                    Spacer()
                    NavigationLink(destination: FollowingView()) {
                        VStack {
                            Text("Following")
                                .font(.headline)
                            Text("\(followingCount)")
                                .font(.subheadline)
                        }
                        .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.vertical, 16)

                HStack {
                    TabButton(title: "Posts", isSelected: selectedTab == "Posts") {
                        selectedTab = "Posts"
                    }
                    Spacer()
                    TabButton(title: "Discussions", isSelected: selectedTab == "Discussions") {
                        selectedTab = "Discussions"
                    }
                    Spacer()
                    TabButton(title: "Reposts", isSelected: selectedTab == "Reposts") {
                        selectedTab = "Reposts"
                    }
                }
                .padding(.horizontal)

                Divider()
                    .padding(.vertical, 8)

                ScrollView {
                    if selectedTab == "Posts" {
                        PostsView(posts: posts)
                    } else if selectedTab == "Discussions" {
                        DiscussionsView()
                    } else if selectedTab == "Reposts" {
                        RepostsView()
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                Task {
                    await fetchProfileData()
                }
            }
        }
    }

    // Fetch profile data from Firestore
    private func fetchProfileData() async {
        guard let userId = viewModel.currentUser?.id else { return }

        do {
            let userDoc = try await Firestore.firestore().collection("users").document(userId).getDocument()
            guard let data = userDoc.data() else { return }

            DispatchQueue.main.async {
                self.followersCount = data["followersCount"] as? Int ?? 0
                self.followingCount = data["followingCount"] as? Int ?? 0
                self.profileImageUrl = data["profileImageUrl"] as? String
            }

            if let profileImageUrl = profileImageUrl, let url = URL(string: profileImageUrl) {
                downloadImage(from: url)
            }
        } catch {
            print("Error fetching user profile data: \(error.localizedDescription)")
        }

        do {
            let querySnapshot = try await Firestore.firestore().collection("posts")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()

            let fetchedPosts = querySnapshot.documents.compactMap { doc -> Post? in
                let data = doc.data()
                return Post(
                    id: doc.documentID,
                    userId: data["userId"] as? String ?? "",
                    content: data["content"] as? String ?? "",
                    timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                    videoUrl: data["videoUrl"] as? String ?? ""
                )
            }

            DispatchQueue.main.async {
                self.posts = fetchedPosts
            }
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }

    // Upload profile image to Firebase Storage
    private func uploadProfileImage(_ image: UIImage) async {
        guard let userId = viewModel.currentUser?.id else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        let storageRef = Storage.storage().reference().child("profile_pictures/\(userId).jpg")

        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            profileImageUrl = url.absoluteString

            try await Firestore.firestore().collection("users").document(userId)
                .updateData(["profileImageUrl": profileImageUrl!])
        } catch {
            print("Error uploading profile image: \(error.localizedDescription)")
        }
    }

    // Download image from URL
    private func downloadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = uiImage
                }
            }
        }
    }
}

struct PostsView: View {
    let posts: [Post]

    var body: some View {
        VStack {
            if posts.isEmpty {
                Text("No posts yet.")
                    .foregroundColor(.gray)
            } else {
                List(posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.content)
                            .font(.body)
                            .foregroundColor(.primary)
                        Text(post.timestamp, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

// Post Model
struct Post: Identifiable {
    let id: String
    let userId: String
    let content: String
    let timestamp: Date
    let videoUrl: String
}

// Other Views
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .blue : .gray)
                .padding(.bottom, 8)
        }
        .overlay(
            isSelected ? Rectangle().frame(height: 2).foregroundColor(.blue).padding(.top, 4) : nil,
            alignment: .bottom
        )
    }
}

// Placeholder Views
struct DiscussionsView: View {
    var body: some View { Text("Discussions will be shown here.") }
}
struct RepostsView: View {
    var body: some View { Text("Reposts will be shown here.") }
}
struct FollowersView: View {
    var body: some View { Text("Followers list will be shown here.") }
}
struct FollowingView: View {
    var body: some View { Text("Following list will be shown here.") }
}


// Preview
struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
