//
//  LoginView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI
// LoginView represents the login screen
struct LoginView: View {
    @StateObject var viewModel = LoginViewModel() // StateObject for the login view model to manage login-related logic and data
    @State private var isSidebarShowing = false // State variable to manage sidebar
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack{
                    Text("IMKMI") // Title
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                    Text("The luxury clothing universe")
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                }
                
                
                VStack {
                    TextField("Email", text: $viewModel.email)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    Button(action: {
                        viewModel.login()
                    }) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(BrandPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    VStack{
                        Text("Still dont have an account?")
                            .font(.caption)
                        
                        NavigationLink(destination: SignupView()) {
                            Text("Sign Up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.5))
                                .foregroundColor(BrandPrimary)
                                .cornerRadius(10)
                        }
                    }.padding(.vertical, 50)
                }
                .padding()
                .edgesIgnoringSafeArea(.all)
                
                Spacer()
                // Footer
                VStack {
                    Text("By logging in, you agree to our Terms of Service and Privacy Policy. You also agree to receive marketing communications from us.")
                        .font(.caption)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .lineLimit(nil) // Allow the text to have unlimited lines
                        .minimumScaleFactor(0.5) // Allow the text to shrink down to half its size if needed
                        .foregroundColor(Color.gray.opacity(1))
                }
            }
            .navigationBarTitle("Login")
            // Alert to displaying login error
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Login Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            
        }
        // Use a stack navigation style to maintain compatibility across devices I add this to tablet pc
        .navigationViewStyle(.stack)
    }
}
