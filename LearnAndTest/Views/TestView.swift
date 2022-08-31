//
//  TestView.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 31.08.2022.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    @State var submitted = false
    
    var body: some View {
        
        if model.currentQuestion != nil {
            VStack (alignment: .leading) {
                //Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.question.count ?? 0)")
                    .padding(.leading, 20)
                
                //Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                //Answers
                ScrollView {
                    VStack {
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self) { index in
                    
                            Button {
                                // Track the selected index
                                selectedAnswerIndex = index
                                
                            } label: {
                        
                                ZStack {
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    } else {
                                        // Answer was selected
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            // User selected the right answer
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        } else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            // User selected the wrong anser
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        } else if index == model.currentQuestion!.correctIndex {
                                            // Show the correct answer
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        } else {
                                            // Rest of the cards remain white
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion!.answers[index])
                                }
                            }.disabled(submitted)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                
                //Submit Button
                Button {
                    // Check if answer has been submitted
                    if submitted == true {
                        model.nextQuestion()
                        
                        // Reset properties
                        submitted = false
                        selectedAnswerIndex = nil
                    } else {
                        // Submit the answer
                        submitted = true
                        // Check the answer and increment contor if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                    
                } label: {
                    ZStack {
                        RectangleCard(color:  .green)
                            .frame(height:48)
                        Text(buttonText)
                            .bold().foregroundColor(.white)
                    }.padding()
                }.disabled(selectedAnswerIndex == nil)
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        } else {
            // Text hasn't load
            ProgressView()
        }
        
    }
    
    var buttonText:String {
        //Check if answer has been submitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.question.count {
                return "Finish"
            } else {
                return "Next"
            }
        } else  {
            return "Submit"
        }
    }
}

/*struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}*/
