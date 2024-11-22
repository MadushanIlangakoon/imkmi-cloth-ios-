//
//  LoginViewModel.swift
//  ClothingStore-iOS
//
//  Created by COBSCCOMPY4231P-15 on 2024-11-10.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    // Published properties
    @Published var email = ""
    @Published var password = ""
    
    @Published var showingAlert = false // Controls the alert show or not
    @Published var alertMessage = "" // Message to be displayed in the alert
    
    //Login Function
    func login() {
        //test email and Password
        print("DEBUG: \(email) , \(password)")
        // Validate the URL for login
        guard let url = URL(string: "http://ec2-52-53-158-252.us-west-1.compute.amazonaws.com:3000/api/login") else {
            print("Invalid URL")
            return
        }
        // Prepare the request
        let requestBody = [
            "email": email,
            "passwd": password
        ]
        // Set up the request with the URL, HTTP method
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")// Set content type to JSON
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])// Convert request to JSON
        //Create Data task
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            //check data was recived
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Update authentication and user status
            if let userResponse = try? JSONDecoder().decode(User.self, from: data) {
                print("DEBUG: Halfway through - userResponse success")
                DispatchQueue.main.async {
                    Authenticator.shared.isAuthenticated = true
                    Authenticator.id = userResponse.id
                    Authenticator.name = userResponse.name
                    Authenticator.email = userResponse.email
                    Authenticator.age = userResponse.age
                    Authenticator.gender = userResponse.gender
                }
            } else {
                //Invalid credentials
                print("DEBUG: Invalid credentials")
                DispatchQueue.main.async {
                    Authenticator.shared.isAuthenticated = false
                    self.showingAlert = true // Trigger the alert
                    self.alertMessage = "Invalid credentials. Try again."
                }
            }
        }.resume()// Start data task
    }
}
