//
//  PaymentView.swift
//  ClothingStore-iOS
//
//  Created by Navin Thamindu on 2024-10-06.
//

import SwiftUI
import LocalAuthentication
struct PaymentView: View {
    // State variables for manage payment and shipping information
    @State private var isSidebarShowing = false
    @State private var name: String = ""
    @State private var addressname: String  = Authenticator.name ?? ""
    @State private var cardNumber: String = ""
    @State private var expDate = ""
    @State private var cvv: String = ""
    @State private var address1: String  = ""
    @State private var address2: String  = ""
    @State private var city: String  = ""
    @State private var country: String  = ""
    
    // Variables to handle payment success and alerts
    @State private var paymentSuccess = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // Binding to manage navigation
    @Binding var rootIsActive : Bool
    @ObservedObject var updateTrigger = CartUpdateTrigger()
    
    
    var body: some View {
        
        VStack {
            NavigationLink(destination: PaymentSuccessView(shouldPopToRootView: self.$rootIsActive, updateTrigger: updateTrigger), isActive: $paymentSuccess) {
                EmptyView()
            }
            
            .isDetailLink(false)
            Spacer()
            Form {
                // Payment Information
                Section(header: Text("Payment Information")) {
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .textContentType(.creditCardNumber)
                    TextField("Exp Date (Eg: 12/30)", text: $expDate)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                        .textContentType(.creditCardSecurityCode)
                }
                
                Section(header: Text("Shipping Details")) {
                    TextField("Name", text: $addressname)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    TextField("Address 1", text: $address1)
                    TextField("Address 2", text: $address2)
                    TextField("City", text: $city)
                    TextField("Country", text: $country)
                }
            }
            // Payment button
            HStack {
                Button(action: {
                    if (validateData()){
                        authenticateUser { success, error in
                            if success {
                                // Authentication was successful, proceed with the payment
                                makePaymentRequest()
                                paymentSuccess = true
                            } else {
                                // Authentication failed
                                print(error?.localizedDescription ?? "Authentication failed")
                                paymentSuccess = false
                            }
                        }
                    }
                    
                }) {
                    Text("Pay")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(BrandPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
        }
        .navigationTitle("Payment Details")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    // Handle user authentication
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        context.localizedFallbackTitle = "Use Passcode" // Optionally customize the fallback button title
        
        // Reason shown in the authentication dialog.
        let reason = "Please authenticate to proceed."
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Authentication was successful
                    completion(true, nil)
                } else {
                    // Authentication failed
                    completion(false, error)
                }
            }
        }
    }
    
    
    func makePaymentRequest() {
        //msking payment request
        let items = GlobalVariables.globalCart.map { "\($0.item.id)-\($0.size)" }.joined(separator: ", ")
        let payment = GlobalVariables.globalCart.reduce(0) { $0 + $1.item.price }
        
        let parameters: [String: Any] = [
            "name": name,
            "payment": payment,
            "addressname": addressname,
            "address1": address1,
            "address2": address2,
            "city": city,
            "items": items,
            "country": country
        ]
        
        print(parameters) //Test
        
        guard let url = URL(string: "http://ec2-52-53-158-252.us-west-1.compute.amazonaws.com:3000/api/bills") else {
            print("Invalid URL") // URL validation check
            return
        }
        // Configure the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Failed to create HTTP body")
            return
        }
        request.httpBody = httpBody
        // Execute the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("Payment successful")
                        // Clear the global cart here
                        print(httpBody)
                        GlobalVariables.globalCart.removeAll()
                    } else {
                        print("Unexpected status code: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
        
    }
    // Validate the input data
    private func validateData()  -> Bool {
        let isNameValid = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isCVVValid = isValidCVV(cvv)
        let isCardValid = isValidCreditCardNumber(cardNumber)
        
        if !isNameValid{
            self.alertMessage = "Enter a valid name"
            self.showingAlert = true
        } else if !isCardValid{
            self.alertMessage = "Enter a valid card"
            self.showingAlert = true
        } else if !isCVVValid{
            self.alertMessage = "Enter a valid CVV"
            self.showingAlert = true
        } else if addressname.isEmpty{
            self.alertMessage = "Enter your Address name"
            self.showingAlert = true
        } else if address1.isEmpty{
            self.alertMessage = "Enter you Adress line 1"
            self.showingAlert = true
        } else if address2.isEmpty{
            self.alertMessage = "Enter your Address line 2"
            self.showingAlert = true
        } else if city.isEmpty{
            self.alertMessage = "Enter your City"
            self.showingAlert = true
        } else if country.isEmpty{
            self.alertMessage = "Enter your Country"
            self.showingAlert = true
        } else {
            return true
        }
        
        return false
    }
    
    private func isValidCVV(_ cvv: String) -> Bool {
        let pattern = "^[0-9]{3,4}$"
        return cvv.range(of: pattern, options: .regularExpression) != nil
    }
    
    private func isValidCreditCardNumber(_ number: String) -> Bool {
        // Visa: Starts with 4
        // MasterCard: Starts with 51-55 or 2221-2720
        // American Express (Amex): Starts with 34 or 37
        // Discover: Starts with 6011, 65, 644-649, 622126-622925
        let pattern = "^4[0-9]{12}(?:[0-9]{3})?$" +         // Visa
        "|^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$" + // MasterCard
        "|^3[47][0-9]{13}$" +                // American Express
        "|^6(?:011|5[0-9]{2}|4[4-9][0-9])[0-9]{12}$" + // Discover
        "|^(?:2131|1800|35\\d{3})\\d{11}$"  // JCB
        
        let regex = try? NSRegularExpression(pattern: pattern)
        return regex?.firstMatch(in: number, options: [], range: NSRange(location: 0, length: number.utf16.count)) != nil
    }
}
