//
//  Models.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 19.08.2022.
//

import Foundation

class Module : Decodable, Identifiable {
    var id: String = ""
    var category: String = ""
    var content: Content = Content()
    var test: Test = Test()
}

class Content : Decodable, Identifiable {
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var lessons: [Lesson] = [Lesson]()
}

struct Lesson : Decodable, Identifiable {
    var id: String = ""
    var title: String = ""
    var video: String = ""
    var duration: String = ""
    var explination: String = ""
}

class Test : Decodable, Identifiable {
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var questions: [Question] = [Question]()
}

class Question : Decodable, Identifiable {
    var id: String = ""
    var content: String = ""
    var correctIndex: Int = 0
    var answers: [String] = [String]()
}

class User {
    var name: String = ""
    var lastModule: Int?
    var lastLesson: Int?
    var lastQuestion: Int?
}

