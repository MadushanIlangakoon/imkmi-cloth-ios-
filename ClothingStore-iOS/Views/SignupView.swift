//
//  SigninView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI
// SignupView represents the sign-up screen
struct SignupView: View {
    @State private var isSidebarShowing = false
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var password2 = ""
    @State private var gender = ""
    @State private var age = ""
    // State variables for handling alerts
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        
        VStack {
            Spacer()
            // Branding Section
            VStack{
                Text("IMKMI")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)  
                Text("The luxury clothing universe")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
            }
            .padding(20)
            // User Input Section
            VStack {
                TextField("Name", text: $name)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .textContentType(.name)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                
                TextField("Age", text: $age)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .keyboardType(.numberPad)
                
                TextField("Gender", text: $gender)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .textContentType(.name)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                
                TextField("Email", text: $email)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                
                // Password confirmation field
                SecureField("Enter Password Again", text: $password2)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                
                Button(action: {
                    // Action for checkout button
                    signUp()
                }) {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(BrandPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .edgesIgnoringSafeArea(.all)
            
            //Footer
            VStack {
                Text("By Signing up, you agree to our Terms of Service and Privacy Policy. You also agree to receive marketing communications from us.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .lineLimit(nil) // Allow the text to have unlimited lines
                    .minimumScaleFactor(0.5) // Allow the text to shrink down to half its size if needed
                    .foregroundColor(Color.gray.opacity(1))
            }
            Spacer()
        }
        .navigationTitle("Sign Up")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Handle user registration
    func signUp() {
        //Validating
        let isNameValid = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isAgeValid = Int(age) != nil && (0...120).contains(Int(age)!)
        let isEmailValid = isValidEmail(email)
        // Check for validation
        if !isNameValid{
            self.alertMessage = "Enter a valid name"
            self.showingAlert = true
        } else if !isAgeValid{
            self.alertMessage = "Enter a valid age"
            self.showingAlert = true
        } else if !isEmailValid{
            self.alertMessage = "Enter a valid email"
            self.showingAlert = true
        }
        
        
        if isNameValid && isAgeValid && isEmailValid {
            // Prepare the API request
            guard let url = URL(string: "http://ec2-52-53-158-252.us-west-1.compute.amazonaws.com:3000/api/users") else {
                self.alertMessage = "Invalid URL."
                self.showingAlert = true
                return
            }
            
            if (!password.isEmpty && password == password2){
                let user = UserUpdate(name: name, email: email, age: Int(age) ?? 0, gender: gender, passwd: password)
                
                guard let jsonData = try? JSONEncoder().encode(user) else {
                    self.alertMessage = "Failed to encode user data."
                    self.showingAlert = true
                    return
                }
                // Setup the HTTP request
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                        DispatchQueue.main.async {
                            self.alertMessage = "Sign up successful!"
                            self.showingAlert = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.alertMessage = "Sign up failed: \(error?.localizedDescription ?? "Unknown error")"
                            self.showingAlert = true
                        }
                    }
                }.resume()
            } else {
                self.alertMessage = "Passwords are not matching"
                self.showingAlert = true
            }
        }
    }
    // Function to validate email
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}

#Preview {
    SignupView()
}
