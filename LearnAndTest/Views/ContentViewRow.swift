//
//  ContentViewRow.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 20.08.2022.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index:Int
    
    var lessonC: Lesson {
        if model.currentModule != nil && index < model.currentModule!.content.lessons.count {
            return model.currentModule!.content.lessons[index]
        } else {
            return Lesson(id: "", title: "", video: "", duration: "", explination: "")
        }
    }
    
    var body: some View {
        
        ZStack (alignment: .leading) {
            Rectangle().foregroundColor(.white).cornerRadius(10).shadow(radius: 5).frame(height: 66)
            HStack (spacing: 30) {
                Text(String(index+1)).bold()
                
                VStack (alignment: .leading){
                    Text(lessonC.title).bold()
                    Text(lessonC.duration)
                }
            }
            .padding()
        }
        .padding(.bottom, 7)
    }
}

