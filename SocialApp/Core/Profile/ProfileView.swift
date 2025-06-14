//
//  ProfileView.swift
//  SocialApp
//
//  Created by hiwot alemu on 11/30/24.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var activeSection: ProfileSection = .profile
    @State private var privacySettings = PrivacySettings()
    
    enum ProfileSection {
        case profile, privacy, security, notifications
    }
    
    struct PrivacySettings {
        var profileVisibility: Visibility = .friends
        var emailVisibility: Visibility = .private
        var activityTracking = false
        
        enum Visibility: String {
            case `public` = "Public"
            case friends = "Friends"
            case `private` = "Private"
        }
    }
    
    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                
                HStack(spacing: 0) {
                    
                    // Sidebar Navigation
                    VStack {
                        // Profile Header
                        VStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            
                            Text(user.fullname)
                                .font(.headline)
                            Text(user.initials)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        
                        // Navigation Sections
                        VStack(alignment: .leading, spacing: 10) {
                            Button(action: { activeSection = .profile }) {
                                HStack {
                                    Image(systemName: "person")
                                    Text("Profile")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(activeSection == .profile ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(10)
                            }
                            .foregroundColor(activeSection == .profile ? .blue : .primary)
                            
                            Button(action: { activeSection = .privacy }) {
                                HStack {
                                    Image(systemName: "shield")
                                    Text("Privacy")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(activeSection == .privacy ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(10)
                            }
                            .foregroundColor(activeSection == .privacy ? .blue : .primary)
                            
                            Button(action: { activeSection = .security }) {
                                HStack {
                                    Image(systemName: "lock")
                                    Text("Security")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(activeSection == .security ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(10)
                            }
                            .foregroundColor(activeSection == .security ? .blue : .primary)
                            
                            Button(action: { activeSection = .notifications }) {
                                HStack {
                                    Image(systemName: "bell")
                                    Text("Notifications")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(activeSection == .notifications ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(10)
                            }
                            .foregroundColor(activeSection == .notifications ? .blue : .primary)
                        }
                        .padding()
                        
                        Spacer()
                        
                        // Logout Button
                        Button(action: {
                                Task {
                                    viewModel.logOut()
                                    
                                    //(withEmail: email, password: password)
                                }
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.square")
                                Text("Log Out")
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                    .frame(width: 380)
                    .background(Color.gray.opacity(0.1))
                    
                    // Main Content
                    Group {
                        switch activeSection {
                        case .profile:
                            ScrollView {
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack(spacing: 15) {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading) {
                                            Text("John Doe")
                                                .font(.title2)
                                            Text("@JohnDoe")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    Group {
                                        LabeledTextField(label: "Email", text: .constant("emma.rodriguez@example.com"))
                                        LabeledTextField(label: "Location", text: .constant("San Francisco, CA"))
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.2), radius: 5)
                            }
                        case .privacy:
                            ScrollView {
                                VStack(spacing: 20) {
                                    PrivacySettingRow(
                                        title: "Profile Visibility",
                                        subtitle: "Who can view your profile",
                                        control: Picker("", selection: $privacySettings.profileVisibility) {
                                            Text("Public").tag(PrivacySettings.Visibility.public)
                                            Text("Friends").tag(PrivacySettings.Visibility.friends)
                                            Text("Private").tag(PrivacySettings.Visibility.private)
                                        }
                                            .pickerStyle(SegmentedPickerStyle())
                                    )
                                    
                                    PrivacySettingRow(
                                        title: "Email Visibility",
                                        subtitle: "Control email exposure",
                                        control: Picker("", selection: $privacySettings.emailVisibility) {
                                            Text("Public").tag(PrivacySettings.Visibility.public)
                                            Text("Friends").tag(PrivacySettings.Visibility.friends)
                                            Text("Private").tag(PrivacySettings.Visibility.private)
                                        }
                                            .pickerStyle(SegmentedPickerStyle())
                                    )
                                    
                                    PrivacySettingRow(
                                        title: "Activity Tracking",
                                        subtitle: "Allow platform to track activity",
                                        control: Toggle("", isOn: $privacySettings.activityTracking)
                                    )
                                }
                                .padding()
                            }
                        case .security:
                            ScrollView {
                                VStack(spacing: 20) {
                                    SecuritySettingRow(
                                        icon: "lock",
                                        title: "Change Password",
                                        subtitle: "Recommended every 3 months",
                                        action: {}
                                    )
                                    
                                    SecuritySettingRow(
                                        icon: "shield",
                                        title: "Two-Factor Authentication",
                                        subtitle: "Additional security layer",
                                        trailingView: AnyView(
                                            HStack {
                                                Text("Enabled")
                                                    .foregroundColor(.green)
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                            }
                                        )
                                    )
                                    
                                    SecuritySettingRow(
                                        icon: "doc.text",
                                        title: "Login History",
                                        subtitle: "Review recent account access",
                                        action: {}
                                    )
                                }
                                .padding()
                            }
                        case .notifications:
                            ScrollView {
                                VStack(spacing: 20) {
                                    NotificationSettingRow(
                                        title: "Email Notifications",
                                        subtitle: "Receive updates via email"
                                    )
                                    
                                    NotificationSettingRow(
                                        title: "Push Notifications",
                                        subtitle: "Real-time mobile alerts",
                                        isOn: false
                                    )
                                }
                                .padding()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .padding()
                }
                .navigationTitle("Account Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    // Supporting Views
    struct LabeledTextField: View {
        let label: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField(label, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
    
    struct PrivacySettingRow<Control: View>: View {
        let title: String
        let subtitle: String
        let control: Control
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                control
            }
        }
    }
    
    struct SecuritySettingRow: View {
        let icon: String
        let title: String
        let subtitle: String
        var action: (() -> Void)? = nil
        var trailingView: AnyView? = nil
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                if let trailingView = trailingView {
                    trailingView
                } else if let action = action {
                    Button("Change") {
                        action()
                    }
                }
            }
        }
    }
    
    struct NotificationSettingRow: View {
        let title: String
        let subtitle: String
        var isOn: Bool = true
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Toggle("", isOn: .constant(isOn))
            }
        }
    }
}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()        /*.environmentObject(AuthViewModel())*/
    }
}














// PEVIOUS CODE
//struct ProfileView: View {
//    @EnvironmentObject var viewModel: AuthViewModel
//    @State private var activeSection: ProfileSection = .profile
//    @State private var privacySettings = PrivacySettings()
//
//    enum ProfileSection {
//        case profile, privacy, security, notifications
//    }
//
//    struct PrivacySettings {
//        var profileVisibility: Visibility = .friends
//        var emailVisibility: Visibility = .private
//        var activityTracking = false
//
//        enum Visibility {
//            case `public`, friends, `private`
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            if let user = viewModel.currentUser {
//                HStack(spacing: 0) {
//                    // Sidebar Navigation
//                    sidebarNavigation(user: user)
//
//                    // Main Content
//                    mainContent(user: user)
//                }
//                .navigationTitle("Account Settings")
//                .navigationBarTitleDisplayMode(.inline)
//            }
//        }
//    }
//
//    private func sidebarNavigation(user: User) -> some View {
//        VStack {
//            // Profile Header
//            VStack {
//                Image(systemName: "person.circle.fill")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 100, height: 100)
//                    .clipShape(Circle())
//
//                Text(user.fullname)
//                    .font(.headline)
//                Text(user.initials)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            .padding()
//
//            // Navigation Sections
//            VStack(alignment: .leading, spacing: 10) {
//                navigationButton(
//                    icon: "person",
//                    title: "Profile",
//                    section: .profile
//                )
//
//                navigationButton(
//                    icon: "shield",
//                    title: "Privacy",
//                    section: .privacy
//                )
//
//                navigationButton(
//                    icon: "lock",
//                    title: "Security",
//                    section: .security
//                )
//
//                navigationButton(
//                    icon: "bell",
//                    title: "Notifications",
//                    section: .notifications
//                )
//            }
//            .padding()
//
//            Spacer()
//
//            // Logout Button
//            Button(action: {
//                // Logout logic
//            }) {
//                HStack {
//                    Image(systemName: "arrow.right.square")
//                    Text("Log Out")
//                }
//                .foregroundColor(.red)
//                .frame(maxWidth: .infinity)
//                .padding()
//            }
//        }
//        .frame(width: 380)
//        .background(Color.gray.opacity(0.1))
//    }
//
//    private func navigationButton(
//        icon: String,
//        title: String,
//        section: ProfileSection
//    ) -> some View {
//        Button(action: {
//            activeSection = section
//        }) {
//            HStack {
//                Image(systemName: icon)
//                Text(title)
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.secondary)
//            }
//            .padding()
//            .background(
//                activeSection == section
//                    ? Color.blue.opacity(0.1)
//                    : Color.clear
//            )
//            .cornerRadius(10)
//        }
//        .foregroundColor(
//            activeSection == section
//                ? .blue
//                : .primary
//        )
//    }
//
//    private func mainContent(user: User) -> some View {
//        Group {
//            switch activeSection {
//            case .profile:
//                profileSection(user: user)
//            case .privacy:
//                privacySection
//            case .security:
//                securitySection
//            case .notifications:
//                notificationsSection
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .background(Color.white)
//        .padding()
//    }
//
//    private func profileSection(user: User) -> some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 15) {
//                HStack(spacing: 15) {
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 100, height: 100)
//                        .clipShape(Circle())
//
//                    VStack(alignment: .leading) {
//                        Text(user.fullname)
//                            .font(.title2)
//                        Text(user.initials)
//                            .foregroundColor(.secondary)
//                    }
//                }
//
//                Divider()
//
//                Group {
//                    LabeledTextField(
//                        label: "Email",
//                        text: .constant(user.email)
//                    )
//
//                    LabeledTextField(
//                        label: "Location",
//                        text: .constant("San Francisco, CA")
//                    )
//                }
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(10)
//            .shadow(color: .gray.opacity(0.2), radius: 5)
//        }
//    }
//
//    private var privacySection: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                PrivacySettingRow(
//                    title: "Profile Visibility",
//                    subtitle: "Who can view your profile",
//                    control: Picker("", selection: $privacySettings.profileVisibility) {
//                        Text("Public").tag(PrivacySettings.Visibility.public)
//                        Text("Friends").tag(PrivacySettings.Visibility.friends)
//                        Text("Private").tag(PrivacySettings.Visibility.private)
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                )
//
//                PrivacySettingRow(
//                    title: "Email Visibility",
//                    subtitle: "Control email exposure",
//                    control: Picker("", selection: $privacySettings.emailVisibility) {
//                        Text("Public").tag(PrivacySettings.Visibility.public)
//                        Text("Friends").tag(PrivacySettings.Visibility.friends)
//                        Text("Private").tag(PrivacySettings.Visibility.private)
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                )
//
//                PrivacySettingRow(
//                    title: "Activity Tracking",
//                    subtitle: "Allow platform to track activity",
//                    control: Toggle("", isOn: $privacySettings.activityTracking)
//                )
//            }
//            .padding()
//        }
//    }
//
//    private var securitySection: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                SecuritySettingRow(
//                    icon: "lock",
//                    title: "Change Password",
//                    subtitle: "Recommended every 3 months",
//                    action: {}
//                )
//
//                SecuritySettingRow(
//                    icon: "shield",
//                    title: "Two-Factor Authentication",
//                    subtitle: "Additional security layer",
//                    trailingView: AnyView(
//                        HStack {
//                            Text("Enabled")
//                                .foregroundColor(.green)
//                            Image(systemName: "checkmark.circle.fill")
//                                .foregroundColor(.green)
//                        }
//                    )
//                )
//
//                SecuritySettingRow(
//                    icon: "doc.text",
//                    title: "Login History",
//                    subtitle: "Review recent account access",
//                    action: {}
//                )
//            }
//            .padding()
//        }
//    }
//
//    private var notificationsSection: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                NotificationSettingRow(
//                    title: "Email Notifications",
//                    subtitle: "Receive updates via email"
//                )
//
//                NotificationSettingRow(
//                    title: "Push Notifications",
//                    subtitle: "Real-time mobile alerts",
//                    isOn: false
//                )
//            }
//            .padding()
//        }
//    }
//}
//
//// Supporting Views
//struct LabeledTextField: View {
//    let label: String
//    @Binding var text: String
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(label)
//                .font(.caption)
//                .foregroundColor(.secondary)
//            TextField(label, text: $text)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//        }
//    }
//}
//
//struct PrivacySettingRow<Control: View>: View {
//    let title: String
//    let subtitle: String
//    let control: Control
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.headline)
//                Text(subtitle)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            Spacer()
//            control
//        }
//    }
//}
//
//struct SecuritySettingRow: View {
//    let icon: String
//    let title: String
//    let subtitle: String
//    var action: (() -> Void)? = nil
//    var trailingView: AnyView? = nil
//
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(.blue)
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.headline)
//                Text(subtitle)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            Spacer()
//
//            if let trailingView = trailingView {
//                trailingView
//            } else if let action = action {
//                Button("Change") {
//                    action()
//                }
//            }
//        }
//    }
//}
//
//struct NotificationSettingRow: View {
//    let title: String
//    let subtitle: String
//    var isOn: Bool = true
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.headline)
//                Text(subtitle)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//            Spacer()
//            Toggle("", isOn: .constant(isOn))
//        }
//    }
//}


