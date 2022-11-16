//
//  LaunchView.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 01.11.2022.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        if model.loggedIn == false {
            LoginView()
                .onAppear {
                    // Check is the user is logged in or out
                    model.checkLogin()
                }
        } else {
            TabView {
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book")
                            Text("Learn")
                        }
                    }
                ProfileView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person")
                            Text("Learn")
                        }
                    }
            }
            /*.onAppear {
                model.getModules()
            }*/
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                model.saveData(writeToDatabase: true)
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
