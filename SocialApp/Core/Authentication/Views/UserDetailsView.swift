//
//  UserDetailsView.swift
//  SocialApp
//
//  Created by hiwot alemu on 12/22/24.
//

import SwiftUI
 
struct UserDetailsView: View {
    @EnvironmentObject var userData: UserData
    @State private var birthday = Date()
    @State private var phoneNumber = ""
    @State private var bio = ""
    @State private var profileImage: Image? = nil
    @State private var showImagePicker = false
    @State private var navigateToProfileView = false  // Add this state variable for navigation

    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                Text("Create Your Profile")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
                
           
                    // Profile Picture Section
                    VStack(spacing: 8) {
                        Button(action: {
                            showImagePicker.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                    )
                                
                                if let profileImage = profileImage {
                                    profileImage
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 120, height: 120)
                                } else {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(selectedImage: $profileImage)
                        }
                        
                        Text("Add Profile Picture")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                
                // Form Fields
                VStack(spacing: 24) {
                    // Username Field (Already filled from previous screen)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextField("Username", text: $userData.username)
                            .textFieldStyle(CustomTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .disabled(true) // Username is already set and cannot be changed
                    }
                    
                    // Birthday Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Your Birthday")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        
                        DatePicker(
                            "Birthday",
                            selection: $birthday,
                            in: ...Date(), // Limit to today or past dates
                            displayedComponents: .date
                        )
                        .datePickerStyle(CompactDatePickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                        .padding(.top, 10)
                    }
                    
                    // Phone Number Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextField("Phone Number", text: $phoneNumber)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.phonePad)
                    }
                    
                    // Bio Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bio")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextField("Write a short bio", text: $bio, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3, reservesSpace: true)
                    }
                }
                
                Spacer()
                NavigationLink(
                                 destination: ProfileView(), // Replace with the actual profile view
                                 isActive: $navigateToProfileView
                ) {
                // Next Button
//                HStack {
//                    Spacer()
                    
                    Button(action: {
                        navigateToProfileView = true
                    }) {
                        Text("Next")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue) // Blue text color
                            .font(.title3) // Adjust font size as needed
                    }
                    .padding(.trailing, 24) // Right padding
                    .padding(.bottom, 10)   // Bottom padding
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
    }
}

// Image Picker
import SwiftUI

struct ImagePicker: View {
    @Binding var selectedImage: Image?
    @Environment(\.dismiss) private var dismiss
    @State private var isImagePickerPresented = false
    @State private var uiImage: UIImage? = nil

    var body: some View {
        VStack {
            Button("Choose Image") {
                isImagePickerPresented.toggle()
            }
            .padding()

            Button("Cancel") {
                dismiss()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isImagePickerPresented) {
            ImagePickerController(selectedImage: $uiImage)
                .onDisappear {
                    if let uiImage = uiImage {
                        selectedImage = Image(uiImage: uiImage)
                    }
                }
        }
    }
}

struct ImagePickerController: View {
    @Binding var selectedImage: UIImage?

    var body: some View {
        ImagePickerView(selectedImage: $selectedImage)
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImage: UIImage?

        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // You can change this to .camera for camera access
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates needed here
    }
}


// Shared User Data Model
class UserData: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var fullname: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
}

// Preview
struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDetailsView().environmentObject(UserData())
        }
    }
}


//
//
//struct UserDetailsView: View {
//    @EnvironmentObject var userData: UserData
//    @State private var birthday = Date()
//    @State private var phoneNumber = ""
//    @State private var bio = ""
//    @State private var profileImage: Image? = nil
//    @State private var showImagePicker = false
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 32) {
//                Text("Create Your Profile")
//                    .font(.system(size: 34, weight: .bold, design: .rounded))
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.top, 40)
//                
//                // Profile Picture Section
//                VStack(spacing: 8) {
//                    Button(action: {
//                        showImagePicker.toggle()
//                    }) {
//                        ZStack {
//                            Circle()
//                                .fill(Color.gray.opacity(0.1))
//                                .frame(width: 120, height: 120)
//                                .overlay(
//                                    Circle()
//                                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
//                                )
//                            
//                            if let profileImage = profileImage {
//                                profileImage
//                                    .resizable()
//                                    .scaledToFill()
//                                    .clipShape(Circle())
//                                    .frame(width: 120, height: 120)
//                            } else {
//                                Image(systemName: "camera.fill")
//                                    .font(.system(size: 40))
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                    .sheet(isPresented: $showImagePicker) {
//                        ImagePicker(selectedImage: $profileImage)
//                    }
//                    
//                    Text("Add Profile Picture")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//
//                .frame(maxWidth: .infinity)
//                .padding(.bottom, 20)
//                
//                // Form Fields
//                VStack(spacing: 24) {
//                    // Username Field (Already filled from previous screen)
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Username")
//                            .foregroundColor(.gray)
//                            .font(.subheadline)
//                        TextField("Username", text: $userData.username)
//                            .textFieldStyle(CustomTextFieldStyle())
//                            .textInputAutocapitalization(.never)
//                            .autocorrectionDisabled()
//                            .disabled(true) // Username is already set and cannot be changed
//                    }
//                    
//                    // Other form fields...
//                }
//                
//                Spacer()
//                
//                HStack {
//                    Spacer()
//                    
//                    Button(action: {
//                        // Logic for saving user details
//                    }) {
//                        Text("Next")
//                            .fontWeight(.semibold)
//                            .foregroundColor(.blue)
//                            .font(.title3)
//                    }
//                    .padding(.trailing, 24)
//                    .padding(.bottom, 10)
//                }
//            }
//            .padding(.horizontal, 24)
//        }
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//
//// Custom TextField Style
//struct CustomTextFieldStyle: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .padding()
//            .background(Color.gray.opacity(0.1))
//            .cornerRadius(12)
//    }
//}
//
//// Image Picker
//struct ImagePicker: View {
//    @Binding var selectedImage: Image?
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        VStack {
//            Button("Choose Image") {
//                // Image picker logic would go here
//            }
//            .padding()
//            
//            Button("Cancel") {
//                dismiss()
//            }
//            .padding()
//        }
//    }
//}
//
//// Shared User Data Model
//class UserData: ObservableObject {
//    @Published var username: String = ""
//    @Published var email: String = ""
//    @Published var fullname: String = ""
//    @Published var password: String = ""
//    @Published var confirmPassword: String = ""
//}
//
//// Preview
//struct UserDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            UserDetailsView().environmentObject(UserData())
//        }
//    }
//}
