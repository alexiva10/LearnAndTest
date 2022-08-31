//
//  ContentModel.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 18.08.2022.
//

import Foundation

class ContentModel: ObservableObject {
    //List of modules
    @Published var modules = [Module]()
    
    //Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    //Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    //Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    //Current lesson explination (for CodeTextView)
    @Published var codeText = NSAttributedString()
    
    var styleData: Data?
    
    //Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    init() {
        getLocalData()
    }
    
    func getLocalData() {
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        do {
            let jsonData = try Data(contentsOf: jsonUrl!)
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            self.modules = modules
        } catch {
            print("Could't parse!")
        }
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        do {
            let styleData = try Data(contentsOf: styleUrl!)
            self.styleData = styleData
        } catch {
            print("Could't parse!")
        }
    }
    
    func beginModule(_ moduleid:Int) {
        //Find index for this module id
        for index in 0..<modules.count {
            if modules[index].id == index {
                currentModuleIndex = index
                break
            }
        }
        //Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        //Check that lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lesson.count {
            currentLessonIndex = lessonIndex
        } else {
            currentLessonIndex = 0
        }
        
        currentLesson = currentModule!.content.lesson[currentLessonIndex]
        codeText = addStyling(currentLesson!.explination)
    }
    
    func nextLesson() {
        // Advance the lesson index
        currentLessonIndex += 1
        // Check that is is withing range
        if currentLessonIndex < currentModule!.content.lesson.count {
            // Set the current lesson property
            currentLesson = currentModule!.content.lesson[currentLessonIndex]
            codeText = addStyling(currentLesson!.explination)
        } else {
            // Reset lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool {
        if currentLessonIndex + 1 < currentModule!.content.lesson.count {
            return true
        } else {
            return false
        }
    }
    
    func beginTest(_ moduleId:Int) {
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question index
        currentQuestionIndex = 0
        if currentModule?.test.question.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.question[currentQuestionIndex]
            // Set the question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() { // Same as nextLesson more or less
        currentQuestionIndex = -1
        
        if currentQuestionIndex < currentModule!.test.question.count {
            currentQuestion = currentModule!.test.question[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        } else {
            currentQuestionIndex = 0
            currentQuestion = nil
        }
    }
                                  
    /*func hasNextQuestion() -> Bool { // Same as hasNextLesson more or less
        if currentQuestionIndex + 1 < currentModule!.test.question.count {
            return true
        } else {
            return false
        }
    }*/
    
    // Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        // Add the styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        // Add the html data
        data.append(Data(htmlString.utf8))
        // Convert to atributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }

        return resultString
    }
}
