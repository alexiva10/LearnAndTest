//
//  LoginView.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 01.11.2022.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var password = ""
    @State var name = ""
    
    var buttonText: String {
        
        if loginMode == Constants.LoginMode.login {
            return "Login"
        } else {
            return "Sign Up"
        }
    }
    
    var body: some View {
        
        VStack (spacing: 20) {
            
            Spacer()
            // Logo
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
            // Title
            Text("Licenta Demo")
            
            Spacer()
            
            // Picker
            Picker(selection: $loginMode) {
                Text("Login")
                    .tag(Constants.LoginMode.login)
                
                Text("Sign Up")
                    .tag(Constants.LoginMode.createAccount)
                
            } label: {
                Text("Hey")
            }
            .pickerStyle(SegmentedPickerStyle())

            
            // Form
            TextField("Email", text: $email)
            
            if loginMode == Constants.LoginMode.createAccount {
                TextField("Name", text: $name)
            }
            SecureField("Password", text: $password)
            
            // Button
            Button {
                if loginMode == Constants.LoginMode.login {
                    
                } else {
                    
                }
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(height:40)
                        .cornerRadius(10)
                    Text(buttonText)
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 40)
        .textFieldStyle(PlainTextFieldStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(ContentModel())
    }
}
