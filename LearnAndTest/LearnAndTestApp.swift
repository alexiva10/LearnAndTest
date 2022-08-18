//
//  LearnAndTestApp.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 18.08.2022.
//

import SwiftUI

@main
struct LearnAndTestApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(ContentModel())
        }
    }
}
