//
//  UserService.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 09.11.2022.
//

import Foundation

class UserService {
    
    var user = User()
    static var shared = UserService()
    
    private init() {
        
    }
}
