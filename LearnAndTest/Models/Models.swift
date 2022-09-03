//
//  Models.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 19.08.2022.
//

import Foundation

class Module : Decodable, Identifiable {
    var id: Int
    var category: String
    var content: Content
    var test: Test
}

class Content : Decodable, Identifiable {
    var id: Int
    var image: String
    var time: String
    var description: String
    var lessons: [Lesson]
}

class Lesson : Decodable, Identifiable {
    var id: Int
    var title: String
    var video: String
    var duration: String
    var explination: String
}

class Test : Decodable, Identifiable {
    var id: Int
    var image: String
    var time: String
    var description: String
    var questions: [Question]
}

class Question : Decodable, Identifiable {
    var id: Int
    var content: String
    var correctIndex: Int
    var answers: [String]
}


