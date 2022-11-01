//
//  ContentModel.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 18.08.2022.
//

import Foundation
import Firebase

class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
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
        // getLocalStyles()
        getModules()
        
        // getRemoteData()
    }
    
    func getLesson(module: Module, completion: @escaping () -> Void) {
        let collection = db.collection("modules").document(module.id).collection("lessons")
        collection.getDocuments { querySnap, error in
            if error == nil && querySnap != nil {
                var lessons = [Lesson]()
                
                for doc in querySnap!.documents {
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explination = doc["explanation"] as? String ?? ""
                    
                    lessons.append(l)
                }
                for (index, m) in self.modules.enumerated() {
                    if m.id == module.id {
                        self.modules[index].content.lessons = lessons
                        
                        completion()
                    }
                }
            }
        }
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        let collection = db.collection("modules").document(module.id).collection("questions")
        collection.getDocuments { querySnap, error in
            if error == nil && querySnap != nil {
                var questions = [Question]()
                
                for doc in querySnap!.documents {
                    var q = Question()
                    
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.content = doc["content"] as? String ?? ""
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    q.answers = doc["answers"] as? [String] ?? [String]()
                    
                    questions.append(q)
                }
                for (index, m) in self.modules.enumerated() {
                    if m.id == module.id {
                        self.modules[index].test.questions = questions
                        
                        completion()
                    }
                }
            }
        }
    }
    
    func getModules() {
        
        getLocalStyles()
        
        let collection = db.collection("modules")
        
        collection.getDocuments { querySnapshot, error in
            if error == nil && querySnapshot != nil {
                var modules = [Module]()
                
                for doc in querySnapshot!.documents {
                    var m = Module()
                    
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    let contentMap = doc["content"] as! [String:Any]
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    
                    let testMap = doc["test"] as! [String:Any]
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    
                    modules.append(m)
                }
                DispatchQueue.main.async {
                    self.modules = modules
                }
            }
        }
    }
    
    func getLocalStyles() {
        /* let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        do {
            let jsonData = try Data(contentsOf: jsonUrl!)
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            self.modules = modules
        } catch {
            print("Couldn't parse local data!")
            print(error)
        } */
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        do {
            let styleData = try Data(contentsOf: styleUrl!)
            self.styleData = styleData
        } catch {
            print("Couldn't parse!")
        }
    }
    
    func getRemoteData() {
        // String path
        let urlString = "https://alexiva10.github.io/LearnAndTest-Data/data2.json"
        
        // Create a url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Could't create url
            return
        }
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            // Check if there is an error
            guard error == nil else {
                return
            }
            // Create json decoder
            do {
                let decoder = JSONDecoder()
                // Decode
                let modules = try decoder.decode([Module].self, from: data!)
                // Apend parsed modules
                self.modules += modules
            } catch  {
                // Couldn't parse
                print("Couldn't parse remote data!")
                print(error)
            }
            
        }
        
        // Kick off data task
        dataTask.resume()
    }
    
    func beginModule(_ moduleid:String) {
        //Find index for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                currentModuleIndex = index
                break
            }
        }
        //Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        //Check that lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        } else {
            currentLessonIndex = 0
        }
        
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explination)
    }
    
    func nextLesson() {
        // Advance the lesson index
        currentLessonIndex += 1
        // Check that is is withing range
        if currentLessonIndex < currentModule!.content.lessons.count {
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explination)
        } else {
            // Reset lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool {
        
        guard currentModule != nil else {
            return false
        }
        if currentLessonIndex + 1 < currentModule!.content.lessons.count {
            return true
        } else {
            return false
        }
    }
    
    func beginTest(_ moduleId:String) {
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question index
        currentQuestionIndex = 0
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            // Set the question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() { // Same as nextLesson more or less
        currentQuestionIndex += 1
        
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
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
