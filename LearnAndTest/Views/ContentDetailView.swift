//
//  ContentDetailView.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 22.08.2022.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            //Show video if valid url
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // Description
            CodeTextView()
            
            // Show Next lesson button only if there is a next lesson
            if model.hasNextLesson() {
                Button {
                    model.nextLesson()
                } label: {
                    
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        Text("Next Lesson: \(model.currentModule!.content.lesson[model.currentLessonIndex + 1].title)")
                            .foregroundColor(Color.white)
                            .bold()
                    }
                }

            }
            else {
                // Show the complete button
                Button {
                    //Take user back to homeview
                    model.currentContentSelected = nil
                } label: {
                    
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        Text("Complete")
                            .foregroundColor(Color.white)
                            .bold()
                    }
                }
            }
            
        }
        .padding()
        .navigationBarTitle(lesson?.title ?? "")
    }
}

/*struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}*/
