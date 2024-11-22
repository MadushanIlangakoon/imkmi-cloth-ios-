//
//  ProfileViewModel.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation
//Published properties
class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var age: String = ""
    @Published var gender: String = ""
    @Published var newpasswd: String = ""
    @Published var newpasswd2: String = ""
    
    @Published var showingAlert: Bool = false // Controls whether the alert
    @Published var receiveReminders: Bool = UserDefaults.standard.bool(forKey: "receiveReminders")
    @Published var receiveNews: Bool = UserDefaults.standard.bool(forKey: "receiveNews")
    @Published var alertMessage: String = "" // Message displayed in the alert
    
    init() {
        // Initialize with values from Authenticator
        name = Authenticator.name ?? ""
        email = Authenticator.email ?? ""
        age = "\(Authenticator.age ?? 0)"
        gender = Authenticator.gender ?? ""
    }
    // Update the user profile on server
    func updateProfile() {
        guard let userID = Authenticator.id, let url = URL(string: "http://ec2-52-53-158-252.us-west-1.compute.amazonaws.com:3000/api/users/\(userID)") else {
            alertMessage = "Invalid URL or User ID"
            showingAlert = true // Show alert if URL or user is invalid
            return
        }
        // Request with the PUT method and set the content type as JSON
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set user defaults settings for the Notification
        UserDefaults.standard.set(receiveNews, forKey: "receiveNews")
        UserDefaults.standard.set(receiveReminders, forKey: "receiveReminders")
        
        //Password Check
        if (newpasswd == newpasswd2) {
            // Create an updated user object to send i
            let updatedUser = UserUpdate(name: name, email: email, age: Int(age) ?? 0, gender: gender, passwd: newpasswd2)
            guard let jsonData = try? JSONEncoder().encode(updatedUser) else { return }
            // Set the request body to JSON data
            request.httpBody = jsonData
            // Send the update request to server
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        if let userResponse = try? JSONDecoder().decode(User.self, from: data) {
                            // Update the Authenticator
                            Authenticator.name = userResponse.name
                            Authenticator.email = userResponse.email
                            Authenticator.age = userResponse.age
                            Authenticator.gender = userResponse.gender
                            self?.showingAlert = true // Trigger the alert
                            self?.alertMessage = "Profile Updated" // Set success message
                        }
                    }
                } else {
                    //   Show an alert with the error message
                    DispatchQueue.main.async {
                        self?.alertMessage = "Failed to update profile: \(error?.localizedDescription ?? "Unknown error")"
                        self?.showingAlert = true
                    }
                }
            }.resume()
        } else {
            //Password validation
            alertMessage = "Passwords do not match"
            showingAlert = true
        }
    }
}
