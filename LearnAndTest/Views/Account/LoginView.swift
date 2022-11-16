//
//  LoginView.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 01.11.2022.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var loginMode = Constants.LoginMode.login
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var errorMessage: String? = nil
    
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
            Group {
                TextField("Email", text: $email)
                
                if loginMode == Constants.LoginMode.createAccount {
                    TextField("Name", text: $name)
                }
           
                SecureField("Password", text: $password)
                
                if errorMessage != nil {
                    Text(errorMessage!)
                }
            }
            
            
            
            // Button
            Button {
                if loginMode == Constants.LoginMode.login {
                    Auth.auth().signIn(withEmail: email,password: password) { result, error in
                        
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        self.errorMessage = nil
                        
                        // Fetch the user meta data
                        self.model.getUserData()
                        
                        // Change the view to logged in view
                        self.model.checkLogin()
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        self.errorMessage = nil
                        
                        let firebaseUser = Auth.auth().currentUser
                        let db = Firestore.firestore()
                        let ref = db.collection("users").document(firebaseUser!.uid)
                        
                        ref.setData(["name":name], merge: true)
                        
                        // Update user meta data
                        let user = UserService.shared.user
                        user.name = name
                        
                        
                        self.model.checkLogin()
                        
                    }
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
