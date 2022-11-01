//
//  LearnAndTestApp.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 18.08.2022.
//

import SwiftUI
import Firebase

@main
struct LearnAndTestApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView().environmentObject(ContentModel())
        }
    }
}
